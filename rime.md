# 配置文件

在 C:\Users\suesai\AppData\Roaming\Rime 下，如果没有下面的文件，则新建立，之后并将如下内容拷贝进去

## weasel.custom.yaml

```yaml
patch:
  "app_options/Code.exe":
    ascii_mode: true
  "app_options/Xshell.exe":
    ascii_mode: true
  "app_options/sublime_text.exe":
    ascii_mode: true
  "app_options/MobaXterm.exe":
    ascii_mode: true
  "app_options/filezilla.exe":
    ascii_mode: true
  "app_options/devenv.exe":
    ascii_mode: true
  "app_options/notepad++.exe":
    ascii_mode: true
  "style/color_scheme": dark_temple
  "style/font_point": 13
  "style/horizontal": true
```

## default.custom.yaml

```yaml
patch:
  "ascii_composer/good_old_caps_lock": true
  "ascii_composer/switch_key":
    Caps_Lock: clear
    Control_L: clear
    Control_R: commit_text
    Shift_L: commit_code
    Shift_R: inline_ascii
  schema_list:
    - {schema: luna_pinyin_simp}
  "switcher/hotkeys":
    - F4
```

## luna_pinyin_simp.custom.yaml

```yaml
patch:
  punctuator/import_preset: default
  punctuator/full_shape:
    "\\": "、"
    "[": "【"
    "]": "】"
    "{": "｛"
    "}": "｝"
    "/": "、"
  punctuator/half_shape:
    "\\": "、"
    "[": "【"
    "]": "】"
    "{": "｛"
    "}": "｝"
    "/": "、"
  switches:
    - name: ascii_mode
      reset: 1
      states: ["中文", "西文"]
    - name: full_shape
      states: ["半角", "全角"]
    - name: zh_simp
      reset: 1
      states: ["漢字", "汉字"]
    - name: ascii_punct
      states: ["。，", "．，"]
```