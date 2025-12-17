switch (uname -s)
	case Linux
		set -gx DOCKER_CONFIG            /etc/docker
end
