alias docker_clean="sudo /usr/bin/docker ps -a | awk '/Exited/ { print \$1 }' | xargs sudo /usr/bin/docker rm"
