## 安装

- MacOS:
  1. `brew install clash-verge-rev`
- Linux:
  1. `aria2c -d . https://github.com/clash-verge-rev/clash-verge-rev/releases/download/v2.4.1/Clash.Verge_2.4.1_amd64.deb`
  2. 安装依赖
  2. `dpkg -i ./Clash.Verge.deb`

## 配置

1. 导入订阅：在“Prifiles”页，将复制的“订阅链接”粘贴在URL中，然后点击“IMPORT”
2. 选择节点：在“Home”页，选择“Current Node”为指定节点，例如“自动选择”或者“香港”
3. 系统代理：在“Settings”页，开启“Tun Mode”，之后无论是正常应用（例如浏览器），特殊应用（例如游戏）还是命令行，都可以使用代理
4. 其他设置：在“Settings”页
  1. 开启“Auto Launch”
  2. 开启“Silent Start”
  3. “Theme Mode”设置为“System”
  4. “Tray Click Event”设置为“Show Tray Menu”
  5. “HotKey Setting”关闭“Enable Global Hotkey”

## 其他

1. 其他应用可以使用 127.0.0.1:7898（即 mixed-port）来使用代理
