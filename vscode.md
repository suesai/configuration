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
	"C_Cpp.autocomplete": "Default",
	"C_Cpp.clang_format_fallbackStyle": "{ BasedOnStyle: Google, IndentWidth: 8, TabWidth: 8, UseTab: ForIndentation, AllowShortIfStatementsOnASingleLine: true, ColumnLimit: 128 }",
	"C_Cpp.clang_format_sortIncludes": false,
	"C_Cpp.default.intelliSenseMode": "linux-gcc-x64",
	"C_Cpp.errorSquiggles": "Enabled",
	"C_Cpp.intelliSenseEngineFallback": "Enabled",
	"C_Cpp.intelliSenseEngine": "Default",
	"C_Cpp.suggestSnippets": false,
	"clang-format.fallbackStyle": "Google",
	"debug.allowBreakpointsEverywhere": true,
	"editor.acceptSuggestionOnEnter": "off",
	"editor.bracketPairColorization.enabled": true,
	"editor.cursorSmoothCaretAnimation": "off",
	"editor.detectIndentation": false,
	"editor.dragAndDrop": false,
	"editor.formatOnType": false,
	"editor.fontFamily": "Consolas",
	"editor.fontLigatures": false,
	"editor.fontSize": 16,
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
	"extensions.autoCheckUpdates": false,
	"extensions.autoUpdate": false,
	"extensions.experimental.affinity": {
		"vscodevim.vim": 1
	},
	"extensions.ignoreRecommendations": true,
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
	"gnuGlobal.globalExecutable": "/usr/local/bin/global",
	"gnuGlobal.gtagsExecutable": "/usr/local/bin/gtags",
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
	"remote.SSH.path": "/usr/bin/ssh",
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
	"shellcheck.executablePath": "/usr/local/bin/shellcheck",
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
	"update.enableWindowsBackgroundUpdates": false,
	"update.mode": "none",
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
	"workbench.colorTheme": "Tomorrow Night",
	"[c]": {
		"editor.defaultFormatter": "ms-vscode.cpptools"
	}
}
```

## .clang-format

```text
---
# 语言: None, Cpp, Java, JavaScript, ObjC, Proto, TableGen, TextProto
Language: Cpp
# BasedOnStyle: Google
# 访问说明符(public、private等)的偏移
AccessModifierOffset: -4
# 开括号(开圆括号、开尖括号、开方括号)后的对齐: Align, DontAlign, AlwaysBreak(总是在开括号后换行)
AlignAfterOpenBracket: AlwaysBreak
AlignArrayOfStructures: Left
# 连续赋值时，对齐所有等号
AlignConsecutiveAssignments: true
# 对齐连续的位域
AlignConsecutiveBitFields: true
# 连续声明时，对齐所有声明的变量名
AlignConsecutiveDeclarations: true
AlignConsecutiveMacros: AcrossEmptyLinesAndComments
# 左对齐逃脱换行(使用反斜杠换行)的反斜杠
AlignEscapedNewlinesLeft: Right
# 水平对齐二元和三元表达式的操作数
AlignOperands: Align
# 对齐连续的尾随的注释
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
# 允许函数声明的所有参数在放在下一行
AllowAllParametersOfDeclarationOnNextLine: true
# 允许短的块放在同一行
AllowShortBlocksOnASingleLine: Empty
# 允许短的case标签放在同一行
AllowShortCaseLabelsOnASingleLine: false
AllowShortEnumsOnASingleLine: true
# 允许短的函数放在同一行: None, InlineOnly(定义在类中), Empty(空函数), Inline(定义在类中，空函数), All
AllowShortFunctionsOnASingleLine: Inline
# 允许短的if语句保持在同一行
AllowShortIfStatementsOnASingleLine: false
AllowShortLambdasOnASingleLine: Inline
# 允许短的循环保持在同一行
AllowShortLoopsOnASingleLine: false
# 总是在定义返回类型后换行(deprecated)
AlwaysBreakAfterDefinitionReturnType: None
# 总是在返回类型后换行: None, All, TopLevel(顶级函数，不包括在类中的函数), 
#   AllDefinitions(所有的定义，不包括声明), TopLevelDefinitions(所有的顶级函数的定义)
AlwaysBreakAfterReturnType: None
# 总是在多行string字面量前换行
AlwaysBreakBeforeMultilineStrings: false
# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: false
# false表示函数实参要么都在同一行，要么都各自一行
BinPackArguments: true
# false表示所有形参要么都在同一行，要么都各自一行
BinPackParameters: true
BitFieldColonSpacing: After
# 大括号换行，只有当BreakBeforeBraces设置为Custom时才有效
BraceWrapping:
  # class定义后面
  AfterClass: false
  # 控制语句后面
  AfterControlStatement: false
  # enum定义后面
  AfterEnum: false
  # 函数定义后面
  AfterFunction: true
  # 命名空间定义后面
  AfterNamespace: false
  # ObjC定义后面
  AfterObjCDeclaration: false
  # struct定义后面
  AfterStruct: false
  # union定义后面
  AfterUnion: false
  # catch之前
  BeforeCatch: false
  # else之前
  BeforeElse: false
  BeforeWhile: false
  # 缩进大括号
  IndentBraces: false
# 在二元运算符前换行: None(在操作符后换行), NonAssignment(在非赋值的操作符前换行), All(在操作符前换行)
BreakBeforeBinaryOperators: None
# 在大括号前换行: Attach(始终将大括号附加到周围的上下文), Linux(除函数、命名空间和类定义，与Attach类似), 
#   Mozilla(除枚举、函数、记录定义，与Attach类似), Stroustrup(除函数定义、catch、else，与Attach类似), 
#   Allman(总是在大括号前换行), GNU(总是在大括号前换行，并对于控制语句的大括号增加额外的缩进), WebKit(在函数前换行), Custom
#   注：这里认为语句块也属于函数
BreakBeforeBraces: Custom
# 在三元运算符前换行
BreakBeforeTernaryOperators: false
# 在构造函数的初始化列表的逗号前换行
BreakConstructorInitializersBeforeComma: false
# 每行字符的限制，0表示没有限制
ColumnLimit: 128
# 描述具有特殊意义的注释的正则表达式，它不应该被分割为多行或以其它方式改变
CommentPragmas: '^ IWYU pragma:'
# 构造函数的初始化列表要么都在同一行，要么都各自一行
ConstructorInitializerAllOnOneLineOrOnePerLine: false
# 构造函数的初始化列表的缩进宽度
ConstructorInitializerIndentWidth: 8
# 延续的行的缩进宽度
ContinuationIndentWidth: 4
# 去除C++11的列表初始化的大括号{后和}前的空格
Cpp11BracedListStyle: false
# 继承最常用的指针和引用的对齐方式
DerivePointerAlignment: false
# 关闭格式化
DisableFormat: false
# 自动检测函数的调用和定义是否被格式为每行一个参数(Experimental)
ExperimentalAutoDetectBinPacking: false
# 需要被解读为foreach循环而不是函数调用的宏
ForEachMacros: [ foreach, Q_FOREACH, BOOST_FOREACH ]
IncludeBlocks: Regroup
# 对#include进行排序，匹配了某正则表达式的#include拥有对应的优先级，匹配不到的则默认优先级为INT_MAX(优先级越小排序越靠前)，
#   可以定义负数优先级从而保证某些#include永远在最前面
IncludeCategories: 
  - Regex: '^"(llvm|llvm-c|clang|clang-c)/'
    Priority: 2
  - Regex: '^(<|"(gtest|isl|json)/)'
    Priority: 3
  - Regex: '.*'
    Priority: 1
# 缩进case标签
IndentCaseLabels: false
# 缩进宽度
IndentWidth: 8
# 函数返回类型换行时，缩进函数声明或函数定义的函数名
IndentWrappedFunctionNames: false
# 保留在块开始处的空行
KeepEmptyLinesAtTheStartOfBlocks: true
# 开始一个块的宏的正则表达式
MacroBlockBegin: ''
# 结束一个块的宏的正则表达式
MacroBlockEnd: ''
# 连续空行的最大数量
MaxEmptyLinesToKeep: 2
# 命名空间的缩进: None, Inner(缩进嵌套的命名空间中的内容), All
NamespaceIndentation: Inner
# 使用ObjC块时缩进宽度
ObjCBlockIndentWidth: 8
# 在ObjC的@property后添加一个空格
ObjCSpaceAfterProperty: false
# 在ObjC的protocol列表前添加一个空格
ObjCSpaceBeforeProtocolList: true
# 在call(后对函数调用换行的penalty
PenaltyBreakBeforeFirstCallParameter: 19
# 在一个注释中引入换行的penalty
PenaltyBreakComment: 300
# 第一次在<<前换行的penalty
PenaltyBreakFirstLessLess: 120
# 在一个字符串字面量中引入换行的penalty
PenaltyBreakString: 1000
# 对于每个在行字符数限制之外的字符的penalty
PenaltyExcessCharacter: 1000000
# 将函数的返回类型放到它自己的行的penalty
PenaltyReturnTypeOnItsOwnLine: 60
# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Right
# 允许重新排版注释
ReflowComments: true
# 允许排序#include
SortIncludes: true
# 在C风格类型转换后添加空格
SpaceAfterCStyleCast: false
# 在赋值运算符之前添加空格
SpaceBeforeAssignmentOperators: true
# 开圆括号之前添加一个空格: Never, ControlStatements, Always
SpaceBeforeParens: ControlStatements
# 在空的圆括号中添加空格
SpaceInEmptyParentheses: false
# 在尾随的评论前添加的空格数(只适用于//)
SpacesBeforeTrailingComments: 2
# 在尖括号的<后和>前添加空格
SpacesInAngles: true
# 在容器(ObjC和JavaScript的数组和字典等)字面量中添加空格
SpacesInContainerLiterals: true
# 在C风格类型转换的括号中添加空格
SpacesInCStyleCastParentheses: false
# 在圆括号的(后和)前添加空格
SpacesInParentheses: false
# 在方括号的[后和]前添加空格，lamda表达式和未指明大小的数组的声明不受影响
SpacesInSquareBrackets: false
# 标准: Cpp03, Cpp11, Auto
Standard: Cpp11
# tab宽度
TabWidth: 8
# 使用tab字符: Never, ForIndentation, ForContinuationAndIndentation, Always
UseTab: ForIndentation
...
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
