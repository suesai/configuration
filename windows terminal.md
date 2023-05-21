```json
{
	// "$schema": "https://aka.ms/terminal-profiles-schema",
	"$schema": "https://raw.githubusercontent.com/microsoft/terminal/master/doc/cascadia/profiles.schema.json",

	"defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",

	"profiles":
	[
		{
			// Make changes here to the powershell.exe profile
			"guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
			"name": "Windows PowerShell",
			"commandline": "powershell.exe",
			"hidden": false,
			"acrylicOpacity" : 0.75,
			"closeOnExit" : false,
			"colorScheme" : "Tomorrow Night Eighties",
			"cursorColor" : "#FFFFFF",
			"cursorShape" : "bar",
			"fontFace" : "Consolas",
			"fontSize" : 12,
			"historySize" : 9001,
			"padding" : "0, 0, 0, 0",
			"snapOnInput" : true,
			"startingDirectory" : "%USERPROFILE%",
			"useAcrylic" : true
		},
		{
			// Make changes here to the cmd.exe profile
			"guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
			"name": "cmd",
			"commandline": "cmd.exe"
		},
		{
			"guid": "{c6eaf9f4-32a7-5fdc-b5cf-066e8a4b1e40}",
			"name": "Ubuntu-18.04",
			"source": "Windows.Terminal.Wsl"
		},
		{
			"guid": "{17801cde-1fe3-440a-95bf-4e3e0bf97e4d}",
			"name": "CentOS",
			"commandline": "ssh.exe susai@192.168.31.101"
		},
		{
			"guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
			"name": "Azure Cloud Shell",
			"source": "Windows.Terminal.Azure"
		}
	],

	// Add custom color schemes to this array
	"schemes": 
	[
		{
			"name": "Tomorrow Night Eighties",
			"black": "#000000",
			"red": "#f2777a",
			"green": "#99cc99",
			"yellow": "#ffcc66",
			"blue": "#6699cc",
			"purple": "#cc99cc",
			"cyan": "#66cccc",
			"white": "#ffffff",
			"brightBlack": "#000000",
			"brightRed": "#f2777a",
			"brightGreen": "#99cc99",
			"brightYellow": "#ffcc66",
			"brightBlue": "#6699cc",
			"brightPurple": "#cc99cc",
			"brightCyan": "#66cccc",
			"brightWhite": "#ffffff",
			"background": "#2d2d2d",
			"foreground": "#cccccc"
		}
	],

	// Add any keybinding overrides to this array.
	// To unbind a default keybinding, set the command to "unbound"
	"keybindings": []
}
```