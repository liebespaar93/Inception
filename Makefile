
nameserver=nameserver_checker.conf
docker_apt_checker=docker_apt_checker.conf
docker_install_checker=docker_install_checker.conf
docker_compose_install_checker=docker_compose_install_checker.conf

debian_arch=$(dpkg --print-architecture)
debian_v_name=$(. /etc/os-release && echo $VERSION_CODENAME)


all : 

$(nameserver):
	@if [ -f /usr/bin/sudo ];\
	then \
		sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf; \
		touch $(nameserver); \
	fi

$(docker_apt_checker):
	sudo apt-get update;
	sudo apt-get install -y ca-certificates curl gnupg;
	sudo install -m 0755 -d /etc/apt/keyrings;
	@echo "\033[38;5;047m[docker_apt_checker]\033[0m: curl a+r start ";
	curl -4fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
	@echo "\033[38;5;047m[docker_apt_checker]\033[0m: chmod a+r start ";
	sudo chmod a+r /etc/apt/keyrings/docker.gpg;
	@echo "\033[38;5;047m[docker_apt_checker]\033[0m: tee strat ";
	echo "deb [arch=$(debian_arch) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian  $(debian_v_name) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null;
	touch $(docker_apt_checker);

$(docker_install_checker):
	sudo apt-get update;
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;
	touch $(docker_install_checker);

$(docker_compose_install_checker):
	curl -SL https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose;
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose;
	chmod +x /usr/bin/docker-compose;
	touch $(docker_compose_install_checker);

set_resolv : $(nameserver)
	@echo "\033[38;5;047m[set_resolv]\033[0m: set_resolv setting"

unset_reslov :
	@if [ -f ./$(nameserver) ]; then rm $(nameserver); fi
	$(shell (sed '/nameserver 8.8.8.8/d' /etc/resolv.conf) | cat > temp; cp temp /etc/resolv.conf ; rm temp)

set_docker_apt : set_resolv  $(docker_apt_checker)
	@echo "\033[38;5;047m[docker_apt]\033[0m: set_docker_apt setting"
	

docker_install : set_docker_apt $(docker_install_checker) docker-compose
	@echo "\033[38;5;047m[docker_install]\033[0m: docker_install install"

unset_docker :
	@echo "\033[38;5;196m[unset_docker]\033[0m: unset_docker unset"
	@if [ -f ./$(docker_apt_checker) ]; then rm $(docker_apt_checker); fi; \
	@if [ -f ./$(docker_install_checker) ]; then rm $(docker_install_checker); fi; \
	@if [ -f ./$(docker_compose_install_checker) ]; then rm $(docker_compose_install_checker); fi; \
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done;

docker-compose : set_docker_apt $(docker_compose_install_checker)
	@echo "\033[38;5;047m[docker-compose]\033[0m: docker-compose install"
