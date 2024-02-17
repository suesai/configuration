1. ssh 超时

* server：修改 /etc/ssh/sshd_config

```bash
ClientAliveInterval 60
ClientAliveCountMax 10080
UseDNS no
TCPKeepAlive yes
```

* server: 修改 /etc/ssh/ssh_config

```bash
StrictHostKeyChecking no
```

* client：修改 ~/.ssh/config

```bash
ServerAliveInterval 60
ServerAliveCountMax 10080
StrictHostKeyChecking no
```

2. 远程连接服务器

* 修改 windows ~/.ssh 及其属下的文件，用户组为 system，用户为自己，只能有一个用户
* 将 ~/.ssh/id_rsa.pub 内容复制到 linux ~/.ssh/authorized_keys
* 修改 linux 的 ~/.ssh 权限为 700，~/.ssh/* 权限为 600
* 修改 /etc/ssh/sshd_config，PermitRootLogin=yes, StrictModes=no, PubkeyAuthentication=yes, PasswordAuthentication=no
* 修改 Remote-SSH 选项，"remote.SSH.showLoginTerminal": true, "remote.SSH.useLocalServer": false, "remote.SSH.path"

