
nameserver=nameserver_checker.conf
docker_apt_checker=docker_apt_checker.conf
docker_install_checker=docker_install_checker.conf

all : 

$(nameserver):
	@if [ -f /usr/bin/sudo ];\
	then \
		sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf; \
		touch $(nameserver); \
	fi

$(docker_apt_checker):
	touch $(docker_apt_checker);

$(docker_install_checker):
	touch $(docker_install_checker);

set_resolv : $(nameserver)

unset_reslov :
	@if [ -f ./$(nameserver) ]; then rm $(nameserver); fi
	$(shell (sed '/nameserver 8.8.8.8/d' /etc/resolv.conf) | cat > temp; cp temp /etc/resolv.conf ; rm temp)

set_docker_apt : set_resolv $(docker_apt_checker)
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done
	sudo apt-get update
	sudo apt-get install ca-certificates curl gnupg
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -4fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	echo \
  	"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  	"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  	sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update

docker_install : set_docker_apt $(docker_install_checker)
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

unset_docker :
	@if [ -f ./$(docker_apt_checker) ]; then rm $(docker_apt_checker); fi
	@if [ -f ./$(docker_install_checker) ]; then rm $(docker_install_checker); fi
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

# docker-compose-up :
