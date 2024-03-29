## karabiner.json

```json
{
	"global": {
		"ask_for_confirmation_before_quitting": true,
		"check_for_updates_on_startup": true,
		"show_in_menu_bar": true,
		"show_profile_name_in_menu_bar": false,
		"unsafe_ui": false
	},
	"profiles": [
		{
			"complex_modifications": {
				"parameters": {
					"basic.simultaneous_threshold_milliseconds": 50,
					"basic.to_delayed_action_delay_milliseconds": 500,
					"basic.to_if_alone_timeout_milliseconds": 1000,
					"basic.to_if_held_down_threshold_milliseconds": 500,
					"mouse_motion_to_scroll.speed": 100
				},
				"rules": [
					{
						"description": "button4 => Cmd+[, button5 => Cmd+]",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
											"^com\\.apple\\.systempreferences$",
											"^com\\.apple\\.finder$"
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"pointing_button": "button4",
									"modifiers": {
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "open_bracket",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
											"^com\\.apple\\.systempreferences$",
											"^com\\.apple\\.finder$"
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"pointing_button": "button5",
									"modifiers": {
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "close_bracket",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Option+Left_arrow => Cmd+[, Option+Right_arrow => Cmd+]",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "left_arrow",
									"modifiers": {
										"mandatory": [
											"option"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "open_bracket",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "right_arrow",
									"modifiers": {
										"mandatory": [
											"option"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "close_bracket",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Cmd+D => show desktop",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "d",
									"modifiers": {
										"mandatory": [
											"command"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "f11"
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+C, Ctrl+V, Ctrl+X => Cmd+C (Copy), Cmd+V (Paste), Cmd+X (Cut)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "c",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "c",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "v",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "v",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "x",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "x",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Z => Cmd+Z (Undo)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "z",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "z",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Y => Cmd+Shift+Y (Redo)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "y",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "z",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+A => Cmd+A (Select all)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "a",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "a",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+S => Cmd+S (Save)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "s",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "s",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+N => Cmd+N (New)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "n",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "n",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+T => Cmd+T (New tab)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "t",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "t",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Shift+T => Cmd+Shift+T (Restore tab)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "t",
									"modifiers": {
										"mandatory": [
											"control",
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "t",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+F => Cmd+F (Find)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "f",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "f",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+W => Cmd+W (Close)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "w",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "w",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Shift+W => Cmd+shift+W (Close Window)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "w",
									"modifiers": {
										"mandatory": [
											"control",
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "w",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Left Click => Cmd+Left Click (select multiple items)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									},
									"pointing_button": "button1"
								},
								"to": [
									{
										"modifiers": [
											"command"
										],
										"pointing_button": "button1"
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Home => Command+Left Arrow (Move cursor to beginning of line)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "home"
								},
								"to": [
									{
										"key_code": "a",
										"modifiers": [
											"control"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "home"
								},
								"to": [
									{
										"key_code": "left_arrow",
										"modifiers": [
											"fn"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Shift+Home => Cmd+Shift+Left arrow (Move cursor to beginning of line with selection)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "home",
									"modifiers": {
										"mandatory": [
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "left_arrow",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Home, Ctrl+Shift+Home => Cmd+Up arrow, Cmd+Shift+Up arrow (Move cursor to beginning of file with and without selection)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "home",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"shift"
										]
									}
								},
								"to": [
									{
										"key_code": "up_arrow",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "End => Command+Right Arrow (Move cursor to end of line)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "end"
								},
								"to": [
									{
										"key_code": "e",
										"modifiers": [
											"control"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "end"
								},
								"to": [
									{
										"key_code": "right_arrow",
										"modifiers": [
											"fn"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Shift+End => Cmd+Shift+Right arrow (Move cursor to end of line with selection)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "end",
									"modifiers": {
										"mandatory": [
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "right_arrow",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+End, Ctrl+Shift+End => Cmd+down arrow, Cmd+Shift+down arrow (Move cursor to end of file with and without selection)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "end",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"shift"
										]
									}
								},
								"to": [
									{
										"key_code": "down_arrow",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+(Shift)+Right/left arrow => Alt+(Shift)+Right/left arrow (Move cursor one word with selection and without selection)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "left_arrow",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"shift"
										]
									}
								},
								"to": [
									{
										"key_code": "left_arrow",
										"modifiers": [
											"option"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "right_arrow",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"shift"
										]
									}
								},
								"to": [
									{
										"key_code": "right_arrow",
										"modifiers": [
											"option"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+L => Cmd+L (Open url location) (Only in browsers)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "l",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "l",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+H => Cmd+Y (History) (Only in browsers)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "h",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "y",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+R => Cmd+R (Reload) (Only in browsers)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "r",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "r",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "F5 => Cmd+r (Reload)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "f5"
								},
								"to": [
									{
										"key_code": "r",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Option+Tab => Cmd+Tab (Switch application)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "tab",
									"modifiers": {
										"mandatory": [
											"option"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "tab",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Alt+F4 => Cmd+Q (Exit application)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "f4",
									"modifiers": {
										"mandatory": [
											"option"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "q",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Shift+Esc => Open Activity Monitor",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "escape",
									"modifiers": {
										"mandatory": [
											"control",
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"shell_command": "open -a 'Activity Monitor.app'"
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Cmd+L => Cmd+Option+Q (Lock Screen)",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "l",
									"modifiers": {
										"mandatory": [
											"command"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "q",
										"modifiers": [
											"control",
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "Ctrl+Insert => Cmd+c, Ctrl+Shift+Insert => Cmd+v",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "insert",
									"modifiers": {
										"mandatory": [
											"control"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "c",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "insert",
									"modifiers": {
										"mandatory": [
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "v",
										"modifiers": [
											"command"
										]
									}
								],
								"type": "basic"
							}
						]
					},
					{
						"description": "PrintScreen for whole, Shift+PrintScreen to select",
						"manipulators": [
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "print_screen",
									"modifiers": {
										"mandatory": [
											"shift"
										],
										"optional": [
											"any"
										]
									}
								},
								"to": [
									{
										"key_code": "4",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							},
							{
								"conditions": [
									{
										"bundle_identifiers": [
										],
										"type": "frontmost_application_if"
									}
								],
								"from": {
									"key_code": "print_screen"
								},
								"to": [
									{
										"key_code": "3",
										"modifiers": [
											"command",
											"shift"
										]
									}
								],
								"type": "basic"
							}
						]
					}
				]
			},
			"devices": [
				{
					"disable_built_in_keyboard_if_exists": false,
					"fn_function_keys": [],
					"identifiers": {
						"is_keyboard": false,
						"is_pointing_device": true,
						"product_id": 12419,
						"vendor_id": 1267
					},
					"ignore": true,
					"manipulate_caps_lock_led": false,
					"simple_modifications": [],
					"treat_as_built_in_keyboard": false
				},
				{
					"disable_built_in_keyboard_if_exists": false,
					"fn_function_keys": [],
					"identifiers": {
						"is_keyboard": true,
						"is_pointing_device": false,
						"product_id": 65535,
						"vendor_id": 1452
					},
					"ignore": false,
					"manipulate_caps_lock_led": true,
					"simple_modifications": [],
					"treat_as_built_in_keyboard": false
				},
				{
					"disable_built_in_keyboard_if_exists": false,
					"fn_function_keys": [],
					"identifiers": {
						"is_keyboard": false,
						"is_pointing_device": true,
						"product_id": 626,
						"vendor_id": 1452
					},
					"ignore": true,
					"manipulate_caps_lock_led": false,
					"simple_modifications": [],
					"treat_as_built_in_keyboard": false
				},
				{
					"disable_built_in_keyboard_if_exists": false,
					"fn_function_keys": [],
					"identifiers": {
						"is_keyboard": false,
						"is_pointing_device": true,
						"product_id": 20499,
						"vendor_id": 10007
					},
					"ignore": false,
					"manipulate_caps_lock_led": false,
					"simple_modifications": [],
					"treat_as_built_in_keyboard": false
				},
				{
					"disable_built_in_keyboard_if_exists": false,
					"fn_function_keys": [],
					"identifiers": {
						"is_keyboard": true,
						"is_pointing_device": false,
						"product_id": 598,
						"vendor_id": 1452
					},
					"ignore": false,
					"manipulate_caps_lock_led": true,
					"simple_modifications": [],
					"treat_as_built_in_keyboard": false
				}
			],
			"fn_function_keys": [
				{
					"from": {
						"key_code": "f1"
					},
					"to": [
						{
							"consumer_key_code": "display_brightness_decrement"
						}
					]
				},
				{
					"from": {
						"key_code": "f2"
					},
					"to": [
						{
							"consumer_key_code": "display_brightness_increment"
						}
					]
				},
				{
					"from": {
						"key_code": "f3"
					},
					"to": [
						{
							"apple_vendor_keyboard_key_code": "mission_control"
						}
					]
				},
				{
					"from": {
						"key_code": "f4"
					},
					"to": [
						{
							"apple_vendor_keyboard_key_code": "launchpad"
						}
					]
				},
				{
					"from": {
						"key_code": "f5"
					},
					"to": [
						{
							"consumer_key_code": "dictation"
						}
					]
				},
				{
					"from": {
						"key_code": "f6"
					},
					"to": [
						{
							"key_code": "f6"
						}
					]
				},
				{
					"from": {
						"key_code": "f7"
					},
					"to": [
						{
							"consumer_key_code": "rewind"
						}
					]
				},
				{
					"from": {
						"key_code": "f8"
					},
					"to": [
						{
							"consumer_key_code": "play_or_pause"
						}
					]
				},
				{
					"from": {
						"key_code": "f9"
					},
					"to": [
						{
							"consumer_key_code": "fast_forward"
						}
					]
				},
				{
					"from": {
						"key_code": "f10"
					},
					"to": [
						{
							"consumer_key_code": "mute"
						}
					]
				},
				{
					"from": {
						"key_code": "f11"
					},
					"to": [
						{
							"consumer_key_code": "volume_decrement"
						}
					]
				},
				{
					"from": {
						"key_code": "f12"
					},
					"to": [
						{
							"consumer_key_code": "volume_increment"
						}
					]
				}
			],
			"name": "Default profile",
			"parameters": {
				"delay_milliseconds_before_open_device": 1000
			},
			"selected": true,
			"simple_modifications": [
			],
			"virtual_hid_keyboard": {
				"country_code": 0,
				"indicate_sticky_modifier_keys_state": true,
				"mouse_key_xy_scale": 100
			}
		}
	]
}
```
