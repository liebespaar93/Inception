

all : $(set_resolv) 

set_resolv :
	for i in /etc/resolv.conf ; do echo $$i; done
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
set_docker : 
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done
	sudo apt-get update
	sudo apt-get install ca-certificates curl gnupg

docker-compose-up :


