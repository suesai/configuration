function where --description "Lookup command description"
	if test (count $argv) -ne 1
		echo "Usage: where command"
		return 1
	end

	set -l cmd $argv[1]
	set -l found 0
	set -l line

	# 检查缩写
	if abbr -q $cmd
		for line in (abbr -s)
			if string match -qr "^abbr .* -- $cmd (?<match>.*)" -- $line
				echo "$cmd is an abbr: $match"
				set found 1
				break
			end
		end
	end

	# 检查别名
	set -l is_alias 0
	for line in (alias)
		if string match -qr "^alias $cmd (?<match>.*)" -- $line
			echo "$cmd is an alias: $match"
			set is_alias 1
			set found    1
			break
		end
	end

	# 检查函数
	if begin test $is_alias -eq 0; and functions -q $cmd; end
		echo "$cmd is a function:"
		functions $cmd
		set found 1
	end

	# 检查内建命令
	if builtin -q $cmd
		echo "$cmd is a builtin"
		set found 1
	end

	# 查找可执行文件路径
	set -l paths
	set -l path
	for dir in $PATH
		set path "$dir/$cmd"
		if test -f "$path" -a -x "$path"
			set -a paths $path
			set found 1
		end
	end
	# 去重并输出
	if test (count $paths) -gt 0
		printf "%s\n" $paths | awk '!x[$0]++' | while read path
			echo "$path"
		end
	end

	if test $found -eq 0
		echo "$cmd not found"
		return 1
	end
end
