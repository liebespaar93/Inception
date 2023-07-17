
nameserver=nameserver_checker.conf
docker_checker=docker_checker.conf

all : set_resolv

$(nameserver):
	touch $(nameserver)
	echo "\nnameserver 8.8.8.8" >> /etc/resolv.conf

set_resolv : $(nameserver)

unset_reslov : 
	@if [ -f ./$(nameserver) ]; then rm $(nameserver); fi
	$(shell (sed '/nameserver 8.8.8.8/d' /etc/resolv.conf) | cat > temp.txt; cp temp.txt /etc/resolv.conf | rm temp.txt)

set_docker : $(docker_checker)
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done
	sudo apt-get update
	sudo apt-get install ca-certificates curl gnupg

unset_docker :
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

# docker-compose-up :

# help:
# 	@echo -n "Shouldn't print a newline"
# 	@echo -n Shouldn\'t print a newline