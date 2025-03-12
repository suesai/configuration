function proxyhp --description "Set http proxy"
	set -gx http_proxy  http://192.168.0.109:8800
	set -gx https_proxy http://192.168.0.109:8800
	set -gx ftp_proxy   http://192.168.0.109:8800
	set -gx no_proxy    127.0.0.1,localhost
end
