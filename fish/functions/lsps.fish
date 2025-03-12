function lsps --description "List process details"
	set -l pid
	set -l thread
	set -l other_args
	set -l args

	while test (count $argv) -gt 0
		switch $argv[1]
			case '-t'
				set thread '1'
			case '-p'
				if test (count $argv) -lt 2
					echo "lsps usage: pid must be followed by -p"
					return 1
				end
				if string match -qvr '^\d*$' -- $argv[2]
					echo "lsps usage: pid must be number"
					return 1
				end
				set pid  $argv[2]
				set argv $argv[2..-1]
			case '*'
				set other_args "$other_args $argv[1]"
		end
		set argv $argv[2..-1]
	end

	if test -n "$thread" -a -n "$pid"
		set args -L -o pid,ppid,pgid,nlwp,lwp,euser,etime:12,time:12,rss:8,wchan:16,stat:5,command -p $pid
	else if test -n "$thread"
		set args -eL -o pid,ppid,pgid,nlwp,lwp,euser,etime:12,time:12,rss:8,wchan:16,stat:5,command
	else if test -n "$pid"
		set args -o pid,ppid,pgid,nlwp,euser,etime:12,time:12,rss:8,wchan:16,stat:5,command -p $pid
	else
		set args -e -o pid,ppid,pgid,nlwp,euser,etime:12,time:12,rss:8,wchan:16,stat:5,command
	end

	set -l line
	set -l header 1
	ps $args $other_args | while read line
		if test $header -eq 1
			echo $line 1>&2
			set header 0
		else
			echo $line
		end
	end
end
