function help --description "Output help of command"
	$argv --help 2>&1 | bat -l help --paging=always --style=plain
end
