配色可以通过如下命令方便查看，`for ((x=0; x<=255; x++)); do echo -e "${x}:\033[38;5;${x}mcolor\033[000m"; done`

1. 修改命令提示符并添加到 ~/.bashrc

```bash
export PS1="\[\033[01;38;5;210m\]\u\[\033[000m\]@\[\033[01;38;5;36m\]\H\[\033[000m\][\[\033[01;38;5;131m\]\t\[\033[000m\]]\[\033[000m\][\[\033[01;38;5;103m\]\#\[\033[000m\]]: \[\033[01;38;5;12m\]\w \[\033[000m\]\n\$ "
export TERM=xterm-256color
ulimit -c unlimited
sysctl -w kernel.core_pattern=core_%e_%s_%u_%g_%p_%t
```

2. 修改目录配色，修改 /etc/DIR_COLORS.256color

```bash
# 原值 DIR 38;5;27
DIR 01;38;5;12     # directory
```

然后执行并添加到 ~/.bashrc

```bash
eval `dircolors /etc/DIR_COLORS.256color`
```

如果想还原目录配色，则执行

```bash
eval `dircolors /etc/DIR_COLORS`
```
