function duf --description "Disk Usage/Free Utility"
	command duf -output mountpoint,size,used,avail,usage,inodes,inodes_usage,type,filesystem -only local,network,fuse,binds,loops $argv
end
