function extract --description "Extract various archive file"
	if test (count $argv) -ne 1
		echo "Usage: extract file"
		return 1
	end

	set -l file $argv[1]

	if test ! -f $file then
		echo "$file does not exist"
		return 1
	end

	switch (string lower -- $file)
		case '*.tar.bz2' '*.tbz' '*.tbz2'
			tar -jxvf $file
		case '*.tar.gz' '*.tgz'
			tar -zxvf $file
		case '*.tar.lrz'
			lrzuntar $file
		case '*.tar.lz'
			lzip -c -d $file | tar -xvf -
		case '*.tar.lz4'
			lz4 -c -d $file | tar -xvf -
		case '*.tar.xz' '*.txz'
			tar --xz -xvf $file
		case '*.tar.zma' '*.tlz'
			tar --lzma -xvf $file
		case '*.tar.zst' '*.tzst'
			tar --zstd -xvf $file
		case '*.tar'
			tar -xvf $file
		case '*.bz2'
			bunzip2 $file
		case '*.cab' '*.exe'
			cabextract $file
		case '*.cpio' '*.obscpio'
			cpio -idmvF $file
		case '*.deb'
			ar vx $file >/dev/null
			set -l ctrl_file (fd "control\.tar\..+")
			set -l data_file (fd "data\.tar\..+")
			mkdir -p control data
			cd control; extract ../$ctrl_file
			cd ../data; extract ../$data_file
			cd ..; rm $ctrl_file $data_file debian-binary
		case '*.gz'
			gunzip -ck $file >(string sub -e -3 (basename $file))
		case '*.lrz'
			lrunzip $file
		case '*.lz'
			lzip -cdk $file >(string sub -e -3 (basename $file))
		case '*.lz4'
			lz4 -d $file
		case '*.lzma'
			unlzma $file
		case '*.rar'
			unrar x -ad $file
		case '*.rpm'
			rpm2cpio $file | cpio --quite -id
		case '*.xz'
			unxz $file
		case '*.z'
			uncompress $file
		case '*.zip' '*.war' '*.jar' '*.ear' '*.sublime-package' '*.ipa' '*.ipsw' '*.xpi' '*.apk' '*.aar' '*.whl' '*.vsix' '*.crx'
			unzip $file
		case '*.zlib'
			zlib-flate -uncompress <$file >(string sub -e -5 (basename $file))
		case '*.zpaq'
			zpaq x $file
		case '*.zst'
			unzstd --stdout $file >(string sub -e -4 (basename $file))
		case '*.7z'
			7z x $file
		case '*'
			echo "Unsupported archive file type: $file"
			return 1
	end
end
