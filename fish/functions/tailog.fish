function tailog --description "Tail -f for log file"
	if test (count $argv) -ne 1
		echo "usage: tailog file"
		return 1
	end
	if not test -f $argv[1]
		echo "usage: tailog file"
		return 1
	end

	tail -F $argv[1] | bat -pp -l log
end
