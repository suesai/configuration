## 插件

1. C/C++: ms-vscode
2. c++: [cpptools](https://github.com/Microsoft/vscode-cpptools/releases)
3. GitLens
4. Remote-SSH
5. Rust
6. rust-analyzer [release](https://github.com/rust-analyzer/rust-analyzer/releases)
7. CodeLLDB
8. C/C++ GNU Global
9. Hex Editor
10. highlight-words
11. ShellCheck
12. x86 and x86_64 Assembly
13. Tomorrow and Tomorrow Night Theme
14. clangd
15. bookmarks
16. multi-command

### 安装 ms-vscode.cpptools 之后再安装 cpptools，如果没办法下载后者，则按照以下步骤

1. 进入C:\Users\用戶名\\.vscode\extensions\ms-vscode.cpptools-0.20.1，打开 package.json，可以看到要下载的 C/C++ language components (Windows)，ClangFormat (Windows)，Visual Studio Windows Debugger 的地址
2. 下载上述三个依赖项，然后解压，得到 bin，debugAdapters，LLVM 这三个文件夹；将 debugAdapters，LLVM 这两个文件夹直接放在 C:\Users\用戶名\\.vscode\extensions\ms-vscode.cpptools-0.20.1 目录下；将 bin 文件夹里的两个可执行文件 Microsoft.VSCode.CPP.Extension.exe，Microsoft.VSCode.CPP.IntelliSense.Msvc.exe，放到 C:\Users\用戶名\\.vscode\extensions\ms-vscode.cpptools-0.20.1\bin 文件夹下
3. 创建一个空文件，命名为 install.lock

## 改源

更新 toolchain: export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static  
更新 rustup: export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup  
更新 crates: $HOME/.cargo/config

```ini
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
replace-with = 'ustc'
[source.ustc]
registry = "git://mirrors.ustc.edu.cn/crates.io-index"
[http]
proxy = "[socks5://]server:<port>"
```

## vscode 报错 “include errors detected”，解决办法

1. 执行 `gcc -v -E -x c++ -`
2. 复制 `#include <...> 搜索从这里开始：` 下边的内容到 c_cpp_properties.json

Linux:  
```json
{
	"configurations": [
		{
			"name": "Linux",
			"includePath": [
				"${workspaceFolder}/**",
				"/usr/lib/gcc/x86_64-redhat-linux/7/../../../../include/c++/7",
				"/usr/lib/gcc/x86_64-redhat-linux/7/../../../../include/c++/7/x86_64-redhat-linux",
				"/usr/lib/gcc/x86_64-redhat-linux/7/../../../../include/c++/7/backward",
				"/usr/lib/gcc/x86_64-redhat-linux/7/include",
				"/usr/local/include",
				"/usr/include"
			],
			"defines": [],
			"compilerPath": "/usr/bin/clang",
			"cStandard": "c11",
			"cppStandard": "c++17",
			"intelliSenseMode": "clang-x64"
		}
	],
	"version": 4
}
```

Windows:  
```json
{
	"configurations": [
		{
			"name": "Win32",
			"includePath": [
				"${workspaceFolder}/**"
			],
			"defines": [
				"_DEBUG",
				"UNICODE",
				"_UNICODE",
				"__WIN32__"
			],
			"windowsSdkVersion": "10.0.17763.0",
			"compilerPath": "cl.exe",
			"cStandard": "c17",
			"cppStandard": "c++17"
		}
	],
	"version": 4
}
```

Mac:  
```json
{
	"configurations": [
		{
			"name": "Mac",
			"includePath": [
				"${workspaceFolder}/**"
			],
			"defines": [],
			"macFrameworkPath": [],
			"compilerPath": "/usr/bin/clang",
			"cStandard": "c11",
			"cppStandard": "c++17",
			"intelliSenseMode": "clang-x64"
		}
	],
	"version": 4
}
```

## settings.json

```json
{
	"breadcrumbs.enabled": true,

	"C_Cpp.autocomplete": "default",
	"C_Cpp.clang_format_fallbackStyle": "{ BasedOnStyle: Google, IndentWidth: 8, TabWidth: 8, UseTab: ForIndentation, AllowShortIfStatementsOnASingleLine: true, ColumnLimit: 128 }",
	"C_Cpp.clang_format_sortIncludes": false,
	"C_Cpp.default.compilerPath": "/usr/bin/clang",
	"C_Cpp.default.intelliSenseMode": "linux-clang-x64",
	"C_Cpp.errorSquiggles": "enabled",
	"C_Cpp.intelliSenseEngineFallback": "enabled",
	"C_Cpp.intelliSenseEngine": "default",
	"C_Cpp.suggestSnippets": false,

	"clang-format.fallbackStyle": "Google",

	"debug.allowBreakpointsEverywhere": true,

	"editor.acceptSuggestionOnEnter": "off",
	"editor.bracketPairColorization.enabled": true,
	"editor.cursorSmoothCaretAnimation": "off",
	"editor.detectIndentation": false,
	"editor.dragAndDrop": false,
	"editor.formatOnType": false,
	"editor.fontFamily": "'IntoneMono Nerd Font Mono'",
	"editor.fontLigatures": false,
	"editor.fontSize": 14,
	"editor.insertSpaces": false,
	"editor.renderControlCharacters": true,
	"editor.renderWhitespace": "boundary",
	"editor.semanticTokenColorCustomizations": {
		"enabled": true
	},
	"editor.smoothScrolling": false,
	"editor.snippetSuggestions": "top",
	"editor.suggest.snippetsPreventQuickSuggestions": false,
	"editor.tabSize": 8,
	"editor.unicodeHighlight.nonBasicASCII": false,

	// "extensions.autoCheckUpdates": false,
	// "extensions.autoUpdate": false,
	"extensions.experimental.affinity": {
		"vscodevim.vim": 1
	},
	// "extensions.ignoreRecommendations": true,

	"files.defaultLanguage": "c",
	"files.encoding": "utf8",
	"files.eol": "\n",
	"files.associations": {
		"*.h": "c"
	},
	"files.watcherExclude": {
		"**/target/**": true
	},

	"git.ignoreMissingGitWarning": true,
	"gitlens.hovers.currentLine.over": "line",

	"highlightwords.box": {
		"light": true,
		"dark": false
	},
	"highlightwords.colors": [
		{ "light": "#b3d9ff", "dark": "cyan" },
		{ "light": "#e6ffb3", "dark": "pink" },
		{ "light": "#b3b3ff", "dark": "lightgreen" },
		{ "light": "#ffd9b3", "dark": "magenta" },
		{ "light": "#ffb3ff", "dark": "cornflowerblue" },
		{ "light": "#b3ffb3", "dark": "orange" },
		{ "light": "#ffff80", "dark": "green" },
		{ "light": "#d1e0e0", "dark": "red" }
	],
	"highlightwords.defaultMode": 1,
	"highlightwords.showSidebar": true,

	"lldb.dereferencePointers": true,
	"lldb.displayFormat": "auto",

	"Lua.develop.enable": true,
	"Lua.runtime.path": [
		"?.lua",
		"?/init.lua",
		"?/?.lua",
		"/sfos/lualibs/?.lua"
	],

	"multiCommand.commands": [
		{
			"command": "multiCommand.multiEscape",
			"sequence": [
				"cancelRenameInput",
				"closeFindWidget",
				"closeMarkersNavigation",
				"closeReferenceSearch",
				"extension.vim_escape",
				"hideSuggestWidget",
				"notifications.clearAll",
				"workbench.action.focusFirstEditorGroup"
			]
		}
	],

	"python.analysis.fixAll": [
		"source.convertImportFormat",
		"source.unusedImports"
	],
	"python.analysis.typeCheckingMode": "basic",

	"remote.SSH.connectTimeout": 60,
	"remote.SSH.remotePlatform": {
		"rlk": "linux"
	},
	"remote.SSH.showLoginTerminal": true,
	"remote.SSH.useLocalServer": true,

	"rust-analyzer.updates.askBeforeDownload": false,
	"rust-analyzer.updates.channel": "nightly",

	"search.collapseResults": "auto",
	"search.searchOnType": false,

	"shellcheck.disableVersionCheck": false,
	"shellcheck.exclude": [
		"SC2016",
		"SC1091"
	],

	"terminal.integrated.commandsToSkipShell": [
		"-workbench.action.quickOpen",
		"-workbench.action.terminal.focusFind",
		"-workbench.action.toggleSidebarVisibility"
	],
	"terminal.integrated.defaultProfile.linux": "zsh",
	"terminal.integrated.defaultProfile.windows": "Git Bash",
	"terminal.integrated.macOptionIsMeta": true,

	// "update.enableWindowsBackgroundUpdates": false,
	// "update.mode": "none",

	"vim.leader": "<space>",
	"vim.camelCaseMotion.enable": true,
	"vim.easymotion": true,
	"vim.enableNeovim": true,
	"vim.foldfix": true,
	"vim.handleKeys": {
		// "<C-/>": true,
		"<C-s>": true
	},
	"vim.highlightedyank.enable": true,
	"vim.hlsearch": true,
	"vim.incsearch": true,
	"vim.insertModeKeyBindingsNonRecursive": [
		{
			"before": ["<C-k>"],
			"command": ["editor.action.triggerParameterHints"]
		}
	],
	"vim.mouseSelectionGoesIntoVisualMode": false,
	"vim.normalModeKeyBindingsNonRecursive": [
		{
			"before": ["K"],
			"commands": ["editor.action.showHover"]
		},
		{
			"before": ["%"],
			"commands": ["editor.action.showHover"]
		},
		{
			"before": ["<leader>", ","],
			"commands": ["workbench.action.quickOpen"]
		},
		{
			"before": ["<leader>", "/"],
			"commands": ["workbench.action.findInFiles"]
		},
		{
			"before": ["g", "r"],
			"commands": ["references-view.findReferences"]
		},
		{
			"before": ["<C-h>"],
			"commands": ["workbench.action.focusLeftGroup"]
		},
		{
			"before": ["<C-l>"],
			"commands": ["workbench.action.focusRightGroup"]
		},
		{
			"before": ["<C-k>"],
			"commands": ["workbench.action.focusAboveGroup"]
		},
		{
			"before": ["<C-j>"],
			"commands": ["workbench.action.focusBelowGroup"]
		},
		{
			"before": ["<leader>", "|"],
			"commands": ["workbench.action.splitEditorToRightGroup"]
		},
		{
			"before": ["<leader>", "-"],
			"commands": ["workbench.action.splitEditorToAboveGroup"]
		},
		{
			"before": ["<leader>", "w", "d"],
			"commands": ["workbench.action.closeActiveEditor"]
		},
		{
			"before": ["L"],
			"commands": ["workbench.action.nextEditor"]
		},
		{
			"before": ["H"],
			"commands": ["workbench.action.previousEditor"]
		},
		// {
		// 	"before": ["<C-/>"],
		// 	"commands": ["workbench.action.terminal.toggleTerminal"]
		// },
		{
			"before": ["g", "d"],
			"commands": ["editor.action.revealDefinition"]
		},
		{
			"before": ["g", "D"],
			"commands": ["editor.action.revealDeclaration"]
		},
		{
			"before": ["g", "I"],
			"commands": ["editor.action.goToImplementation"]
		},
		{
			"before": ["g", "y"],
			"commands": ["editor.action.goToTypeDefinition"]
		},
		{
			"before": ["<leader>", "r", "n"],
			"commands": ["editor.action.rename"]
		},
		{
			"before": ["<leader>", "g", "g"],
			"commands": ["workbench.view.scm"]
		},
		{
			"before": ["<leader>", "h"],
			"commands": ["highlightwords.addHighlight"]
		},
		{
			"before": ["<leader>", "m", "t"],
			"commands": ["bookmarks.toggle"]
		},
		{
			"before": ["<leader>", "m", "a"],
			"commands": ["bookmarks.listFromAllFiles"]
		},
		{
			"before": ["]", "d"],
			"commands": ["editor.action.marker.nextInFiles"]
		},
		{
			"before": ["[", "d"],
			"commands": ["editor.action.marker.prevInFiles"]
		},
		{
			"before": ["]", "c"],
			"commands": ["editor.action.marker.nextChange"]
		},
		{
			"before": ["[", "c"],
			"commands": ["editor.action.marker.previousChange"]
		},
		{
			"before": ["<Esc>"],
			"commands": [":nohl", "<Esc>"]
		},
		{
			"before": ["<C-left>"],
			"commands": ["workbench.action.toggleEditorWidths"]
		},
		{
			"before": ["<C-right>"],
			"commands": ["workbench.action.toggleEditorWidths"]
		},
		{
			"before": ["<leader>", "e"],
			"commands": ["workbench.action.toggleSidebarVisibility"]
		},
		{
			"before": ["`", "."],
			"commands": ["workbench.action.navigateToLastEditLocation"]
		},
		{
			"before": ["<C-s>"],
			"commands": ["workbench.action.files.save"]
		},
		{
			"before": ["<C-f>"],
			"commands": ["actions.find"]
		}
	],
	"vim.scroll": 0,
	"vim.shell": "/bin/zsh",
	"vim.showcmd": true,
	"vim.surround": true,
	"vim.useCtrlKeys": true,
	"vim.useSystemClipboard": true,
	"vim.vimrc.enable": false,
	"vim.visualModeKeyBindingsNonReursive": [
		{
			"before": ["<leader>", "/"],
			"commands": ["workbench.action.findInFiles"]
		},
		{
			"before": ["<C-f>"],
			"commands": ["actions.find"]
		},
		{
			"before": ["%"],
			"commands": ["editor.action.selectToBracket"]
		},
		{
			"before": ["g", "r"],
			"commands": ["references-view.findReferences"]
		}
	],

	"window.commandCenter": false,
}
```

## keybindings.json

```json
// Place your key bindings in this file to override the defaults
[
	{
		"key": "ctrl+p",
		"command": "-cursorUp",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+p",
		"command": "-list.focusUp",
		"when": "listFocus && !inputFocus"
	},
	{
		"key": "ctrl+p",
		"command": "-selectPrevCodeAction",
		"when": "codeActionMenuVisible"
	},
	{
		"key": "ctrl+p",
		"command": "-selectPrevSuggestion",
		"when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion"
	},
	{
		"key": "ctrl+p",
		"command": "-showPrevParameterHint",
		"when": "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible"
	},
	{
		"key": "ctrl+p",
		"command": "workbench.action.quickOpen"
	},
	{
		"key": "cmd+p",
		"command": "-workbench.action.quickOpen"
	},
	{
		"key": "shift+cmd+p",
		"command": "-workbench.action.showCommands"
	},
	{
		"key": "ctrl+/",
		"command": "-workbench.action.terminal.sendSequence",
		"when": "terminalFocus"
	},
	{
		"key": "ctrl+/",
		"command": "editor.action.commentLine",
		"when": "editorTextFocus && !editorReadonly"
	},
	{
		"key": "ctrl+shift+p",
		"command": "workbench.action.showCommands"
	},
	{
		"key": "cmd+/",
		"command": "-editor.action.commentLine",
		"when": "editorTextFocus && !editorReadonly"
	},
	{
		"key": "cmd+[",
		"command": "-editor.action.outdentLines",
		"when": "editorTextFocus && !editorReadonly"
	},
	{
		"key": "cmd+[",
		"command": "workbench.action.navigateBack",
		"when": "canNavigateBack"
	},
	{
		"key": "ctrl+-",
		"command": "-workbench.action.navigateBack",
		"when": "canNavigateBack"
	},
	{
		"key": "cmd+]",
		"command": "-editor.action.indentLines",
		"when": "editorTextFocus && !editorReadonly"
	},
	{
		"key": "cmd+]",
		"command": "workbench.action.navigateForward",
		"when": "canNavigateForward"
	},
	{
		"key": "ctrl+shift+-",
		"command": "-workbench.action.navigateForward",
		"when": "canNavigateForward"
	},
	{
		"key": "ctrl+c",
		"command": "editor.action.clipboardCopyAction"
	},
	{
		"key": "cmd+c",
		"command": "-editor.action.clipboardCopyAction"
	},
	{
		"key": "ctrl+v",
		"command": "editor.action.clipboardPasteAction"
	},
	{
		"key": "cmd+v",
		"command": "-editor.action.clipboardPasteAction"
	},
	{
		"key": "ctrl+x",
		"command": "editor.action.clipboardCutAction"
	},
	{
		"key": "cmd+x",
		"command": "-editor.action.clipboardCutAction"
	},
	{
		"key": "ctrl+1",
		"command": "-workbench.action.openEditorAtIndex1"
	},
	{
		"key": "ctrl+f1",
		"command": "highlightwords.addHighlight"
	},
	{
		"key": "ctrl+shift+f1",
		"command": "highlightwords.removeAllHighlights"
	},
	{
		"key": "ctrl+f",
		"command": "-cursorRight",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+f",
		"command": "actions.find",
		"when": "editorFocus || editorIsOpen"
	},
	{
		"key": "cmd+f",
		"command": "-actions.find",
		"when": "editorFocus || editorIsOpen"
	},
	{
		"key": "ctrl+shift+f",
		"command": "workbench.action.findInFiles"
	},
	{
		"key": "shift+cmd+f",
		"command": "-workbench.action.findInFiles"
	},
	{
		"key": "ctrl+shift+e",
		"command": "-cursorLineEndSelect",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+shift+e",
		"command": "workbench.view.explorer",
		"when": "viewContainer.workbench.view.explorer.enabled"
	},
	{
		"key": "shift+cmd+e",
		"command": "-workbench.view.explorer",
		"when": "viewContainer.workbench.view.explorer.enabled"
	},
	{
		"key": "cmd+right",
		"command": "-editor.action.inlineSuggest.acceptNextWord",
		"when": "inlineSuggestionVisible && !editorReadonly"
	},
	{
		"key": "cmd+right",
		"command": "-cursorEnd",
		"when": "textInputFocus"
	},
	{
		"key": "cmd+right",
		"command": "-workbench.action.terminal.sendSequence",
		"when": "terminalFocus"
	},
	{
		"key": "alt+0",
		"command": "workbench.action.focusActiveEditorGroup"
	},
	{
		"key": "alt+right",
		"command": "-breadcrumbs.focusNext",
		"when": "breadcrumbsActive && breadcrumbsVisible"
	},
	{
		"key": "alt+right",
		"command": "-breadcrumbs.focusNextWithPicker",
		"when": "breadcrumbsActive && breadcrumbsVisible && listFocus && !inputFocus"
	},
	{
		"key": "alt+right",
		"command": "-cursorWordEndRight",
		"when": "textInputFocus"
	},
	{
		"key": "alt+right",
		"command": "-gitlens.key.alt+right",
		"when": "gitlens:key:alt+right"
	},
	{
		"key": "shift+alt+right",
		"command": "-cursorWordEndRightSelect",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+right",
		"command": "cursorWordRight",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+shift+right",
		"command": "-editor.action.smartSelect.expand",
		"when": "editorTextFocus"
	},
	{
		"key": "ctrl+shift+right",
		"command": "cursorWordRightSelect",
		"when": "textInputFocus"
	},
	{
		"key": "cmd+left",
		"command": "-cursorHome",
		"when": "textInputFocus"
	},
	{
		"key": "cmd+left",
		"command": "-list.collapseAll",
		"when": "listFocus && !inputFocus"
	},
	{
		"key": "cmd+left",
		"command": "-workbench.action.terminal.sendSequence",
		"when": "terminalFocus"
	},
	{
		"key": "ctrl+left",
		"command": "cursorWordLeft",
		"when": "textInputFocus"
	},
	{
		"key": "alt+left",
		"command": "-breadcrumbs.focusPrevious",
		"when": "breadcrumbsActive && breadcrumbsVisible"
	},
	{
		"key": "alt+left",
		"command": "-breadcrumbs.focusPreviousWithPicker",
		"when": "breadcrumbsActive && breadcrumbsVisible && listFocus && !inputFocus"
	},
	{
		"key": "alt+left",
		"command": "-gitlens.key.alt+left",
		"when": "gitlens:key:alt+left"
	},
	{
		"key": "alt+left",
		"command": "-cursorWordLeft",
		"when": "textInputFocus"
	},
	{
		"key": "shift+alt+left",
		"command": "-cursorWordLeftSelect",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+shift+left",
		"command": "-editor.action.smartSelect.shrink",
		"when": "editorTextFocus"
	},
	{
		"key": "ctrl+shift+left",
		"command": "cursorWordLeftSelect",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+z",
		"command": "undo"
	},
	{
		"key": "cmd+z",
		"command": "-undo"
	},
	{
		"key": "ctrl+y",
		"command": "redo"
	},
	{
		"key": "shift+cmd+z",
		"command": "-redo"
	},
	{
		"key": "ctrl+a",
		"command": "-cursorLineStart",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+a",
		"command": "editor.action.selectAll"
	},
	{
		"key": "cmd+a",
		"command": "-editor.action.selectAll"
	},
	{
		"key": "ctrl+s",
		"command": "workbench.action.files.save"
	},
	{
		"key": "cmd+s",
		"command": "-workbench.action.files.save"
	},
	{
		"key": "ctrl+n",
		"command": "-workbench.action.quickOpenSelectNext",
		"when": "inQuickOpen"
	},
	{
		"key": "ctrl+n",
		"command": "-cursorDown",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+n",
		"command": "-list.focusDown",
		"when": "listFocus && !inputFocus"
	},
	{
		"key": "ctrl+n",
		"command": "-selectNextCodeAction",
		"when": "codeActionMenuVisible"
	},
	{
		"key": "ctrl+n",
		"command": "-selectNextSuggestion",
		"when": "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus || suggestWidgetVisible && textInputFocus && !suggestWidgetHasFocusedSuggestion"
	},
	{
		"key": "ctrl+n",
		"command": "-showNextParameterHint",
		"when": "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible"
	},
	{
		"key": "ctrl+n",
		"command": "workbench.action.newWindow"
	},
	{
		"key": "cmd+n",
		"command": "-workbench.action.files.newUntitledFile"
	},
	{
		"key": "shift+cmd+n",
		"command": "-workbench.action.newWindow"
	},
	{
		"key": "ctrl+t",
		"command": "workbench.action.files.newUntitledFile"
	},
	{
		"key": "ctrl+t",
		"command": "-editor.action.transposeLetters",
		"when": "textInputFocus && !editorReadonly"
	},
	{
		"key": "ctrl+shift+t",
		"command": "workbench.action.reopenClosedEditor"
	},
	{
		"key": "shift+cmd+t",
		"command": "-workbench.action.reopenClosedEditor"
	},
	{
		"key": "ctrl+w",
		"command": "-workbench.action.switchWindow"
	},
	{
		"key": "ctrl+w",
		"command": "workbench.action.closeActiveEditor"
	},
	{
		"key": "cmd+w",
		"command": "-workbench.action.closeActiveEditor"
	},
	{
		"key": "ctrl+shift+w",
		"command": "workbench.action.closeWindow",
		"when": "!editorIsOpen && !multipleEditorGroups"
	},
	{
		"key": "cmd+w",
		"command": "-workbench.action.closeWindow",
		"when": "!editorIsOpen && !multipleEditorGroups"
	},
	{
		"key": "ctrl+shift+w",
		"command": "workbench.action.closeWindow"
	},
	{
		"key": "shift+cmd+w",
		"command": "-workbench.action.closeWindow"
	},
	{
		"key": "cmd+home",
		"command": "-workbench.action.terminal.scrollToTop",
		"when": "terminalFocus && terminalHasBeenCreated && !terminalAltBufferActive || terminalFocus && terminalProcessSupported && !terminalAltBufferActive"
	},
	{
		"key": "ctrl+home",
		"command": "cursorTop",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+shift+home",
		"command": "cursorTopSelect",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+end",
		"command": "cursorBottom",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+shift+end",
		"command": "cursorBottomSelect",
		"when": "textInputFocus"
	},
	{
		"key": "cmd+up",
		"command": "-cursorTop",
		"when": "textInputFocus"
	},
	{
		"key": "shift+cmd+up",
		"command": "-cursorTopSelect",
		"when": "textInputFocus"
	},
	{
		"key": "cmd+down",
		"command": "-cursorBottom",
		"when": "textInputFocus"
	},
	{
		"key": "shift+cmd+down",
		"command": "-cursorBottomSelect",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+b",
		"command": "-cursorLeft",
		"when": "textInputFocus"
	},
	{
		"key": "ctrl+b",
		"command": "workbench.action.toggleSidebarVisibility"
	},
	{
		"key": "cmd+b",
		"command": "-workbench.action.toggleSidebarVisibility"
	},
	{
		"key": "ctrl+shift+r",
		"command": "-editor.action.refactor",
		"when": "editorHasCodeActionsProvider && textInputFocus && !editorReadonly"
	},
	{
		"key": "ctrl+shift+r",
		"command": "-workbench.action.quickOpenNavigatePreviousInRecentFilesPicker",
		"when": "inQuickOpen && inRecentFilesPicker"
	},
	{
		"key": "ctrl+shift+r",
		"command": "workbench.view.extension.references-view"
	},
]
```
