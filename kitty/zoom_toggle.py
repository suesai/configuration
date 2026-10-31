#!/usr/bin/env python3
"""Toggle the active kitty tab between the stack layout and its previous layout."""

from __future__ import annotations

from typing import TYPE_CHECKING

from kittens.tui.handler import result_handler

if TYPE_CHECKING:
    from kitty.boss import Boss

ZOOM_LAYOUT = "stack"


def main(args: list[str]) -> None:
    """Satisfy the custom-kitten interface; the action runs in handle_result."""


@result_handler(no_ui=True)
def handle_result(
    args: list[str],
    answer: str,
    target_window_id: int,
    boss: Boss,
) -> None:
    """Zoom the active tab, or restore the layout used before zooming."""
    tab = boss.active_tab
    if tab is None or len(tab.windows) <= 1:
        return

    # toggle_layout() restores the previous layout when leaving stack mode.
    tab.toggle_layout(ZOOM_LAYOUT)
