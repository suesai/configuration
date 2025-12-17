function proxyhp --description "Set http proxy"
	set -gx http_proxy  http://127.0.0.1:7897
	set -gx https_proxy http://127.0.0.1:7897
	set -gx ftp_proxy   http://127.0.0.1:7897
	set -gx no_proxy    127.0.0.1,localhost
end
