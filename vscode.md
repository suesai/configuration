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

如果在 Windows 上使用，需要保证 head.exe（C:\Program Files\Git\usr\bin）和 gtags.exe（C:\global\bin）在系统 PATH 中。

```json
{
	"breadcrumbs.enabled": true,

	"C_Cpp.autocomplete": "default",
	"C_Cpp.clang_format_fallbackStyle": "{ BasedOnStyle: Google, IndentWidth: 8, TabWidth: 8, UseTab: ForIndentation, AllowShortIfStatementsOnASingleLine: true, ColumnLimit: 128 }",
	"C_Cpp.clang_format_sortIncludes": false,
	"C_Cpp.default.intelliSenseMode": "linux-clang-x64",
	"C_Cpp.errorSquiggles": "enabled",
	"C_Cpp.intelliSenseEngineFallback": "enabled",
	"C_Cpp.intelliSenseEngine": "default",
	"C_Cpp.suggestSnippets": false,

	"chat.titleBar.openInAgentsWindow.enabled": false,
	"chat.titleBar.signIn.enabled": false,

	"clang-format.fallbackStyle": "Google",

	"debug.allowBreakpointsEverywhere": true,

	"editor.acceptSuggestionOnEnter": "off",
	"editor.bracketPairColorization.enabled": true,
	"editor.copyWithSyntaxHighlighting": false,
	"editor.cursorSmoothCaretAnimation": "off",
	"editor.detectIndentation": false,
	"editor.dragAndDrop": false,
	"editor.editContext": false,
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

	// "extensions.autoCheckUpdates": false,
	// "extensions.autoUpdate": "off",
	"extensions.experimental.affinity": {
		"vscodevim.vim": 1
	},
	"extensions.ignoreRecommendations": true,

	"files.autoGuessEncoding": true,
	"files.defaultLanguage": "c",
	"files.encoding": "utf8",
	"files.eol": "\n",
	"files.associations": {
		"*.h": "c"
	},
	"files.watcherExclude": {
		"**/target/**": true
	},

	"git.autofetch": true,
	"git.ignoreMissingGitWarning": true,
	"gitlens.keymap": "none",
	"gitlens.hovers.currentLine.over": "line",

	// "gnuGlobal.globalExecutable": "C:\\global\\bin\\global.exe",
	// "gnuGlobal.gtagsExecutable": "C:\\global\\bin\\gtags.exe",

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
			"command": "multiCommand.escape",
			"sequence": [
				"cancelRenameInput",
				"closeFindWidget",
				"closeMarkersNavigation",
				"closeReferenceSearch",
				"extension.vim_escape",
				"hideSuggestWidget",
				"notifications.clearAll",
				"workbench.action.focusActiveEditorGroup"
			]
		}
	],

	"python.analysis.fixAll": [
		"source.convertImportFormat",
		"source.unusedImports"
	],
	"python.analysis.typeCheckingMode": "basic",

	"remote.SSH.connectTimeout": 60,
	// "remote.SSH.path": "C:\\Program Files\\Git\\usr\\bin\\ssh.exe",
	"remote.SSH.remotePlatform": {
		"rlk": "linux"
	},
	"remote.SSH.showLoginTerminal": true,
	"remote.SSH.useLocalServer": true,

	"rust-analyzer.updates.askBeforeDownload": false,
	"rust-analyzer.updates.channel": "nightly",

	"search.collapseResults": "auto",
	"search.searchOnType": false,
	"search.seedWithNearestWord": false,

	"shellcheck.disableVersionCheck": false,
	// "shellcheck.executablePath": "C:\\Program Files\\utils\\shellcheck.exe",
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
	"vim.flash.enable": true,
	"vim.foldfix": true,
	"vim.handleKeys": {
		// "<C-p>": false,
		"<C-/>": true
	},
	"vim.highlightedyank.enable": true,
	"vim.visualstar": true,
	"vim.hlsearch": true,
	"vim.incsearch": true,
	"vim.insertModeKeyBindingsNonRecursive": [
		{
			"before":   [ "<C-k>" ],
			"commands": [ "editor.action.triggerParameterHints" ]
		}
	],
	"vim.mouseSelectionGoesIntoVisualMode": false,
	"vim.normalModeKeyBindingsNonRecursive": [
		{
			"before":   [ "<Esc>" ],
			"commands": [ ":nohl", "closeFindWidget", "<Esc>" ]
		},
		{
			"before":   [ "/" ],
			"after":    [ "<leader>", "<leader>", "/" ]
		},
		{
			"before":   [ "%" ],
			"commands": [ "editor.action.jumpToBracket" ]
		},
		{
			"before":   [ "]", "b" ],
			"commands": [ "workbench.action.nextEditor" ]
		},
		{
			"before":   [ "[", "b" ],
			"commands": [ "workbench.action.previousEditor" ]
		},
		{
			"before":   [ "]", "d" ],
			"commands": [ "editor.action.marker.nextInFiles" ]
		},
		{
			"before":   [ "[", "d" ],
			"commands": [ "editor.action.marker.prevInFiles" ]
		},
		{
			"before":   [ "]", "g" ],
			"commands": [ "workbench.action.editor.nextChange" ]
		},
		{
			"before":   [ "[", "g" ],
			"commands": [ "workbench.action.editor.previousChange" ]
		},
		{
			"before":   [ "]", "e" ],
			"commands": [ "workbench.action.navigateForwardInEditLocations" ]
		},
		{
			"before":   [ "[", "e" ],
			"commands": [ "workbench.action.navigateBackInEditLocations" ]
		},
		{
			"before":   [ "]", "f" ],
			"after":    [ "]", "]" ]
		},
		{
			"before":   [ "[", "f" ],
			"after":    [ "[", "[" ]
		},
		{
			"before":   [ "]", "F" ],
			"after":    [ "/", "^", "}", "<enter>" ]
		},
		{
			"before":   [ "[", "F" ],
			"after":    [ "?", "^", "}", "<enter>" ]
		},
		{
			"before":   [ "K" ],
			"commands": [ "editor.action.showHover" ]
		},
		{
			"before":   [ "H", "H" ],
			"commands": [ "editor.action.outdentLines" ]
		},
		{
			"before":   [ "L", "L" ],
			"commands": [ "editor.action.indentLines" ]
		},
		{
			"before":   [ "f", "<enter>" ],
			"commands": [ "highlightwords.addHighlight" ]
		},
		{
			"before":   [ "f", "<BS>" ],
			"commands": [ "highlightwords.removeHighlight" ]
		},
		{
			"before":   [ "g", "d" ],
			"commands": [ "editor.action.revealDefinition" ]
		},
		{
			"before":   [ "g", "D" ],
			"commands": [ "editor.action.revealDeclaration" ]
		},
		{
			"before":   [ "g", "I" ],
			"commands": [ "editor.action.goToImplementation" ]
		},
		{
			"before":   [ "g", "y" ],
			"commands": [ "editor.action.goToTypeDefinition" ]
		},
		{
			"before":   [ "g", "z", "d" ],
			"after":    [ "<plugds>" ]
		},
		{
			"before":   [ "g", "z", "r" ],
			"after":    [ "<plugcs>" ]
		},
		{
			"before":   [ "<C-h>" ],
			"commands": [ "workbench.action.focusLeftGroup" ]
		},
		{
			"before":   [ "<C-l>" ],
			"commands": [ "workbench.action.focusRightGroup" ]
		},
		{
			"before":   [ "<C-k>" ],
			"commands": [ "workbench.action.focusAboveGroup" ]
		},
		{
			"before":   [ "<C-j>" ],
			"commands": [ "workbench.action.focusBelowGroup" ]
		},
		{
			"before":   [ "<C-i>" ],
			"commands": [ "workbench.action.navigateForward" ]
		},
		{
			"before":   [ "<C-o>" ],
			"commands": [ "workbench.action.navigateBack" ]
		},
		{
			"before":   [ "<C-left>" ],
			"commands": [ "workbench.action.toggleEditorWidths" ]
		},
		{
			"before":   [ "<C-right>" ],
			"commands": [ "workbench.action.toggleEditorWidths" ]
		},
		{
			"before":   [ "<leader>", "/" ],
			"commands": [ "editor.action.commentLine" ]
		},
		{
			"before":   [ "<leader>", "|" ],
			"commands": [ "workbench.action.splitEditorToRightGroup" ]
		},
		{
			"before":   [ "<leader>", "-" ],
			"commands": [ "workbench.action.splitEditorToAboveGroup" ]
		},
		{
			"before":   [ "<leader>", "c" ],
			"commands": [ "workbench.action.closeActiveEditor" ]
		},
		{
			"before":   [ "<leader>", "C" ],
			"commands": [ "workbench.action.revertAndCloseActiveEditor" ]
		},
		{
			"before":   [ "<leader>", "e" ],
			"commands": [ "workbench.action.toggleSidebarVisibility" ]
		},
		{
			"before":   [ "<leader>", "f", "/" ],
			"commands": ["actions.find"]
		},
		{
			"before":   [ "<leader>", "f", "'" ],
			"commands": [ ":marks" ]
		},
		{
			"before":   [ "<leader>", "f", "c" ],
			"after":    [ "v", "i", "w" ],
			"commands": [ { "command": "workbench.action.findInFiles", "args": { "triggerSearch": true } } ],
			"silent":   true
		},
		{
			"before":   [ "<leader>", "f", "f" ],
			"commands": [ "workbench.action.quickOpen" ]
		},
		{
			"before":   [ "<leader>", "f", "k" ],
			"commands": [ "workbench.action.showCommands" ]
		},
		{
			"before":   [ "<leader>", "f", "n" ],
			"commands": [ "notifications.showList" ]
		},
		{
			"before":   [ "<leader>", "f", "r" ],
			"commands": [ ":reg" ]
		},
		{
			"before":   [ "<leader>", "f", "w" ],
			"commands": [ "workbench.action.findInFiles" ]
		},
		{
			"before":   [ "<leader>", "g", "g" ],
			"commands": [ "workbench.view.scm" ]
		},
		{
			"before":   [ "<leader>", "g", "r" ],
			"commands": [ "git.revertSelectedRanges" ]
		},
		{
			"before":   [ "<leader>", "l", "r" ],
			"commands": [ "editor.action.rename" ]
		},
		{
			"before":   [ "<leader>", "l", "R" ],
			"commands": [ "references-view.findReferences" ]
		},
		{
			"before":   [ "<leader>", "l", "s" ],
			"commands": [ "workbench.action.gotoSymbol" ]
		},
		{
			"before":   [ "<leader>", "l", "S" ],
			"commands": [ "outline.focus" ]
		},
		{
			"before":   [ "<leader>", "l", "G" ],
			"commands": [ "workbench.action.showAllSymbols" ]
		},
		{
			"before":   [ "<leader>", "l", "w" ],
			"commands": [ "C_Cpp.SwitchHeaderSource" ]
		},
		{
			"before":   [ "<leader>", "l", "D" ],
			"commands": [ "workbench.action.problems.focus" ]
		},
		{
			"before":   [ "<leader>", "l", "f" ],
			"commands": [ "editor.action.formatDocument" ]
		},
		{
			"before":   [ "<leader>", "n" ],
			"commands": [ "workbench.action.files.newUntitledFile" ]
		},
		{
			"before":   [ "<leader>", "o" ],
			"commands": [ "workbench.view.explorer" ]
		},
		{
			"before":   [ "<leader>", "s", "f" ],
			"commands": [ "editor.action.startFindReplaceAction" ]
		},
		{
			"before":   [ "<leader>", "s", "s" ],
			"commands": [ "workbench.action.replaceInFiles" ]
		},
		{
			"before":   [ "<leader>", "t", "h" ],
			"commands": [ "workbench.action.terminal.toggleTerminal" ]
		},
		{
			"before":   [ "<leader>", "u", "D" ],
			"commands": [ "notifications.clearAll" ]
		},
		{
			"before":   [ "<leader>", "u", "w" ],
			"commands": [ "editor.action.toggleWordWrap" ]
		},
		{
			"before":   [ "<leader>", "w" ],
			"commands": [ "workbench.action.files.save" ]
		},
		{
			"before":   [ "<leader>", "<leader>", "s" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "s" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "f" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "F" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "T" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "f" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "F" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "T" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "w" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "l" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "h" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "e" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "b" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "g", "e" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "j" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "k" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "2", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "w" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "e" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "j", "k" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "j" ],
			"commands": []
		}
	],
	"vim.operatorPendingModeKeyBindingsNonRecursive": [
		{
			"before":   [ "g", "_" ],
			"after":    [ "$" ]
		}
	],
	"vim.scroll": 0,
	"vim.showcmd": true,
	"vim.showMarksInGutter": true,
	"vim.surround": true,
	"vim.useCtrlKeys": true,
	"vim.useSystemClipboard": true,
	"vim.vimrc.enable": false,
	"vim.visualModeKeyBindingsNonRecursive": [
		{
			"before":   [ "H" ],
			"commands": [ "editor.action.outdentLines" ]
		},
		{
			"before":   [ "L" ],
			"commands": [ "editor.action.indentLines" ]
		},
		{
			"before":   [ "g", "_" ],
			"after":    [ "$", "h" ]
		},
		{
			"before":   [ "g", "z", "a" ],
			"after":    [ "S" ]
		},
		{
			"before":   [ "<C-i>" ],
			"commands": [ "workbench.action.navigateForward" ]
		},
		{
			"before":   [ "<C-o>" ],
			"commands": [ "workbench.action.navigateBack" ]
		},
		{
			"before":   [ "<leader>", "/" ],
			"commands": ["editor.action.commentLine"]
		},
		{
			"before":   [ "<leader>", "f", "w" ],
			"commands": [ "workbench.action.findInFiles" ]
		},
		{
			"before":   [ "<leader>", "f", "/" ],
			"commands": [ "actions.find" ]
		},
		{
			"before":   [ "<leader>", "l", "R" ],
			"commands": [ "references-view.findReferences" ]
		},
		{
			"before":   [ "<leader>", "<leader>", "s" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "s" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "f" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "F" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "2", "T" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "f" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "F" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "T" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "w" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "l" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "h" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "e" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "b" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "g", "e" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "j" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "k" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "2", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "t" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "w" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "e" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "b", "d", "j", "k" ],
			"commands": []
		},
		{
			"before":   [ "<leader>", "<leader>", "<leader>", "j" ],
			"commands": []
		}
	],

	"window.commandCenter": false,
	"workbench.colorTheme": "Dark Modern",
	"workbench.layoutControl.enabled": false,
	"workbench.secondarySideBar.defaultVisibility": "hidden"
}
```

## keybindings.json

```json
// Place your key bindings in this file to override the defaults
[
	{
		"key":     "escape",
		"command": "search.action.focusSearchList",
		"when":    "searchInputBoxFocus"
	},
	{
		"key":     "escape",
		"command": "workbench.scm.action.focusNextResourceGroup",
		"when":    "textInputFocus && scmRepository && !editorTextFocus && !suggestWidgetVisible && !editorHoverVisible && !inlineSuggestionVisible"
	},
	{
		"key":     "escape",
		"command": "problems.action.focusProblemsFromFilter",
		"when":    "problemsFilterFocus"
	},
	{
		"key":     "escape",
		"command": "workbench.action.focusPanel",
		"when":    "outputFilterFocus"
	},
	{
		"key":     "space o",
		"command": "workbench.action.focusActiveEditorGroup",
		"when":    "!textInputFocus && !inputFocus && !terminalFocus"
	},
	{
		"key":     "ctrl+oem_plus",
		"command": "-workbench.action.zoomIn"
	},
	{
		"key":     "ctrl+oem_minus",
		"command": "-workbench.action.zoomOut"
	},
	{
		"key":     "ctrl+shift+oem_plus",
		"command": "-workbench.action.zoomIn"
	},
	{
		"key":     "ctrl+shift+oem_minus",
		"command": "-workbench.action.zoomOut"
	},
	{
		"key":     "ctrl+numpad0",
		"command": "-workbench.action.zoomReset"
	},
	{
		"key":     "ctrl+numpad_add",
		"command": "-workbench.action.zoomIn"
	},
	{
		"key":     "ctrl+numpad_subtract",
		"command": "-workbench.action.zoomOut"
	},
	{
		"key":     "ctrl+f1",
		"command": "highlightwords.addHighlight"
	},
	{
		"key":     "ctrl+shift+f1",
		"command": "highlightwords.removeAllHighlights"
	},
	{
		"key":     "ctrl+shift+r",
		"command": "references-view.tree.focus",
	},
	{
		"key":     "ctrl+shift+r",
		"command": "-editor.action.refactor"
	},
	{
		"key":     "ctrl+shift+r",
		"command": "-rerunSearchEditorSearch"
	},
	{
		"key":     "ctrl+shift+r",
		"command": "-workbench.action.quickOpenNavigatePreviousInRecentFilesPicker"
	},
	{
		"key":     "ctrl+shift+r ctrl+i",
		"command": "-editor.action.codeAction"
	},
	{
		"key":     "ctrl+shift+r ctrl+e",
		"command": "-editor.action.codeAction"
	},
	{
		"key":     "alt+j",
		"command": "vim.remap",
		"when":    "editorTextFocus && vim.active && vim.mode == 'Normal'",
		"args":    { "commands": [ { "command": "editor.action.moveLinesDownAction" } ] }
	},
	{
		"key":     "alt+k",
		"command": "vim.remap",
		"when":    "editorTextFocus && vim.active && vim.mode == 'Normal'",
		"args":    { "commands": [ { "command": "editor.action.moveLinesUpAction" } ] }
	},
	{
		"key":     "alt+j",
		"command": "vim.remap",
		"when":    "editorTextFocus && vim.active && (vim.mode == 'Visual' || vim.mode == 'VisualLine' || vim.mode == 'VisualBlock')",
		"args":    { "commands": [ { "command": "editor.action.moveLinesDownAction" } ] }
	},
	{
		"key":     "alt+k",
		"command": "vim.remap",
		"when":    "editorTextFocus && vim.active && (vim.mode == 'Visual' || vim.mode == 'VisualLine' || vim.mode == 'VisualBlock')",
		"args":    { "commands": [ { "command": "editor.action.moveLinesUpAction" } ] }
	}
]
```
