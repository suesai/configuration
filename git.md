# .gitconfig

```ini
[core]
	editor = nvim
	pager = delta

[user]
	email = suesaiup@qq.com
	name = suesai

[alias]
	co = checkout
	ci = commit
	st = status
	br = branch
	lg = log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s - %Cblue%cn%Creset %Cgreen(%cr) %C(bold blue)%Creset' --abbrev-commit --date=format:'%Y-%m-%d %H:%M:%S'
	type = cat-file -t
	dump = cat-file -p

[interactive]
	diffFilter = delta --color-only

[delta]
	navigate = true
	dark = true
	line-numbers = true
	side-by-side = true
	paging = always

[merge]
	conflictstyle = diff3

[diff]
	colorMoved = default
```

## 其他

需要安装的包：
1. git-delta
