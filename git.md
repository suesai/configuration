```ini
[user]
	email = suesaiup@qq.com
	name = suesai

[alias]
	co = checkout
	ci = commit
	st = status
	br = branch
	l = log --graph --pretty=oneline --abbrev-commit
	lg = log --all --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%Creset' --abbrev-commit --date=relative
	hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short
	type = cat-file -t
	dump = cat-file -p
```