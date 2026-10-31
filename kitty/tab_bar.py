"""A centred, equal-width custom tab bar for kitty.

All tabs share the same width. They use a comfortable preferred width while
there is room, then shrink together when kitty reduces the per-tab budget.
"""

import sys
from collections.abc import Callable

from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_title,
    wcswidth,
)


def _make_cocoa_os_window_dragger() -> Callable[[], bool]:
    """Create a function that natively drags the current kitty OS window."""
    if sys.platform != "darwin":
        return lambda: False

    try:
        import ctypes

        objc = ctypes.CDLL("/usr/lib/libobjc.A.dylib")
        appkit = ctypes.CDLL(
            "/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit"
        )
        objc.objc_getClass.argtypes = [ctypes.c_char_p]
        objc.objc_getClass.restype = ctypes.c_void_p
        objc.sel_registerName.argtypes = [ctypes.c_char_p]
        objc.sel_registerName.restype = ctypes.c_void_p
    except (ImportError, OSError, AttributeError):
        return lambda: False

    call_object_method = ctypes.CFUNCTYPE(
        ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p
    )(("objc_msgSend", objc))
    perform_window_drag = ctypes.CFUNCTYPE(
        None, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p
    )(("objc_msgSend", objc))
    current_event_selector = objc.sel_registerName(b"currentEvent")
    window_selector = objc.sel_registerName(b"window")
    perform_drag_selector = objc.sel_registerName(
        b"performWindowDragWithEvent:"
    )

    def drag_current_window() -> bool:
        try:
            app = ctypes.c_void_p.in_dll(appkit, "NSApp").value
            if not app:
                return False
            event = call_object_method(app, current_event_selector)
            if not event:
                return False
            window = call_object_method(event, window_selector)
            if not window:
                return False
            perform_window_drag(window, perform_drag_selector, event)
            return True
        except (AttributeError, OSError, ValueError):
            return False

    return drag_current_window


def _disable_new_tab_on_blank_tab_bar_double_click() -> None:
    """Make blank tab-bar drags move the OS window and suppress new tabs.

    kitty 0.49 handles tab-bar clicks before normal ``mouse_map`` actions.
    Its blank-area double click calls ``TabManager.new_tab()`` directly. Wrap
    that call only while the tab-bar handler is running and the click has
    object id 0, which is the empty part of the bar. A left press in that same
    area starts a native macOS window drag instead.
    """
    from functools import wraps

    from kitty.fast_data_types import GLFW_MOUSE_BUTTON_LEFT, GLFW_PRESS
    from kitty.tabs import TabManager

    patch_marker = "_kitty_blank_tab_bar_double_click_is_patched"
    patch_version_attribute = "_kitty_blank_tab_bar_patch_version"
    current_patch_version = getattr(TabManager, patch_version_attribute, 0)
    if current_patch_version >= 2:
        return

    current_handle_tab_bar_mouse = TabManager.handle_tab_bar_mouse
    current_new_tab = TabManager.new_tab
    if current_patch_version:
        original_handle_tab_bar_mouse = getattr(
            current_handle_tab_bar_mouse,
            "__wrapped__",
            current_handle_tab_bar_mouse,
        )
        original_new_tab = getattr(
            current_new_tab, "__wrapped__", current_new_tab
        )
    else:
        original_handle_tab_bar_mouse = current_handle_tab_bar_mouse
        original_new_tab = current_new_tab
    handler_depth_attribute = "_kitty_tab_bar_mouse_handler_depth"
    drag_os_window = _make_cocoa_os_window_dragger()

    @wraps(original_handle_tab_bar_mouse)
    def handle_tab_bar_mouse(self, x, y, button, modifiers, action):
        if button == GLFW_MOUSE_BUTTON_LEFT and action == GLFW_PRESS:
            if self.tab_bar.tab_id_at(int(x), int(y)) == 0 and drag_os_window():
                self.recent_tab_bar_mouse_events.clear()
                return None

        depth = getattr(self, handler_depth_attribute, 0)
        setattr(self, handler_depth_attribute, depth + 1)
        try:
            return original_handle_tab_bar_mouse(
                self, x, y, button, modifiers, action
            )
        finally:
            if depth:
                setattr(self, handler_depth_attribute, depth)
            else:
                delattr(self, handler_depth_attribute)

    @wraps(original_new_tab)
    def new_tab(self, *args, **kwargs):
        if getattr(self, handler_depth_attribute, 0):
            events = getattr(self, "recent_tab_bar_mouse_events", ())
            if events and events[-1].object_id == 0:
                return None
        return original_new_tab(self, *args, **kwargs)

    TabManager.handle_tab_bar_mouse = handle_tab_bar_mouse
    TabManager.new_tab = new_tab
    setattr(TabManager, patch_marker, True)
    setattr(TabManager, patch_version_attribute, 2)


_disable_new_tab_on_blank_tab_bar_double_click()


LEFT_CAP = "\ue0b6"
RIGHT_CAP = "\ue0b4"
CAP_WIDTH = wcswidth(LEFT_CAP + RIGHT_CAP)

# Each tab owns one trailing cell for the gap. The visible pill is one cell
# narrower, making every pill exactly the same visual width.
# The gap occupies one cell, so this makes the visible pill exactly 1.5x its
# previous width (44 cells -> 66 cells).
PREFERRED_TAB_WIDTH = 67
GAP_WIDTH = 1
PREFERRED_HORIZONTAL_PADDING = 1
ACTIVE_TAB_MARKER = "• "


def _title_prefix(index: int) -> str:
    """Return the part of the title added by tab-bar.conf."""
    # Cmd+1 ... Cmd+9 are mapped to goto_tab. Do not advertise Cmd+10+.
    shortcut = "⌘" if index <= 9 else ""
    return f"{shortcut}{index} "


def _rendered_title_width(draw_data: DrawData, tab: TabBarData, index: int) -> int:
    """Estimate the rendered title width so its visible text can be centred."""
    prefix = _title_prefix(index)
    if tab.is_active:
        prefix += ACTIVE_TAB_MARKER
        if tab.needs_attention:
            prefix += draw_data.bell_on_tab
    else:
        # Inactive tabs show a dot, unless command completion has raised a
        # bell, in which case the bell replaces the dot.
        prefix += draw_data.bell_on_tab if tab.needs_attention else ACTIVE_TAB_MARKER
    if tab.has_activity_since_last_focus:
        prefix += draw_data.tab_activity_symbol
    return max(0, wcswidth(prefix + tab.title))


def _tab_geometry(max_tab_length: int) -> tuple[int, int]:
    """Return the full cell width and the width available inside the caps."""
    cell_width = PREFERRED_TAB_WIDTH
    if max_tab_length > 0:
        # kitty gives the same budget to every tab, so all pills shrink together.
        cell_width = min(cell_width, max_tab_length + GAP_WIDTH)

    pill_width = max(0, cell_width - GAP_WIDTH)
    body_width = max(0, pill_width - CAP_WIDTH)
    return cell_width, body_width


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Draw one equal-width tab pill and return the cursor after its gap."""
    tab_fg = screen.cursor.fg
    tab_bg = screen.cursor.bg
    default_bg = as_rgb(int(draw_data.default_bg))

    cell_width, body_width = _tab_geometry(max_tab_length)

    # There is not enough room for two caps and at least one title cell.
    if body_width == 0:
        screen.cursor.bg = default_bg
        screen.draw(" " * cell_width)
        return screen.cursor.x

    # The left semicircle is the tab colour cutting into the bar background.
    screen.cursor.fg = tab_bg
    screen.cursor.bg = default_bg
    screen.draw(LEFT_CAP)

    body_start = screen.cursor.x
    body_end = body_start + body_width
    screen.cursor.fg = tab_fg
    screen.cursor.bg = tab_bg

    padding = min(PREFERRED_HORIZONTAL_PADDING, max(0, (body_width - 1) // 2))
    title_width = max(1, body_width - padding * 2)
    rendered_title_width = _rendered_title_width(draw_data, tab, index)
    if draw_data.max_tab_title_length > 0:
        rendered_title_width = min(
            rendered_title_width, draw_data.max_tab_title_length
        )
    rendered_title_width = min(title_width, rendered_title_width)
    left_pad = max(0, (title_width - rendered_title_width) // 2)
    title_budget = max(1, title_width - left_pad)
    if draw_data.max_tab_title_length > 0:
        title_budget = min(title_budget, draw_data.max_tab_title_length)

    screen.draw(" " * (padding + left_pad))
    # draw_title() uses max_tab_title_length as its hard clipping boundary.
    # Keep that boundary inside this pill so a narrow tab cannot overflow.
    title_draw_data = draw_data._replace(max_tab_title_length=title_budget)
    draw_title(
        title_draw_data,
        screen,
        tab,
        index,
        title_budget,
    )

    # Fill the unused part of this tab so every pill ends at the same column.
    screen.cursor.fg = tab_fg
    screen.cursor.bg = tab_bg
    remaining_width = body_end - screen.cursor.x
    if remaining_width > 0:
        screen.draw(" " * remaining_width)

    # The right semicircle returns to the bar background to close the pill.
    screen.cursor.fg = tab_bg
    screen.cursor.bg = default_bg
    screen.draw(RIGHT_CAP)

    # Draw the trailing gap here so the cell extent is also equal for every tab.
    screen.cursor.bg = default_bg
    screen.draw(" " * GAP_WIDTH)

    return screen.cursor.x
