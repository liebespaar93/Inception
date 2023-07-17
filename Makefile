
NAMESERVER=nameserver_checker.conf
DOCKER_APT_CHECKER=docker_apt_checker.conf
DOCKER_INSTALL_CHECKER=docker_install_checker.conf
DOCKER_COMPOSE_INSTALL_CHECKER=docker_compose_install_checker.conf

DOCKER_COMPOSE_RUN=docker_compose_run.conf

ROOTDIR = $(abspath $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))
VOLUME_MARIADB=$(ROOTDIR)/srcs/requirements/mariadb/volume
VOLUME_WORDPRESS=$(ROOTDIR)/srcs/requirements/wordpress/volume

WHOAMI    := $(shell whoami)

all : 

$(NAMESERVER):
	@echo "\033[38;5;047m[NAMESERVER]\033[0m: add nameserver 8.8.8.8 ";
	@if [ -f /usr/bin/sudo ];\
	then \
		sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf; \
		touch $(NAMESERVER); \
	fi

$(DOCKER_APT_CHECKER):
	sudo apt-get update;
	sudo apt-get install -y ca-certificates curl gnupg;
	sudo install -m 0755 -d /etc/apt/keyrings;
	@echo "\033[38;5;047m[DOCKER_APT_CHECKER]\033[0m: curl a+r start ";
	curl -4fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
	@echo "\033[38;5;047m[DOCKER_APT_CHECKER]\033[0m: chmod a+r start ";
	sudo chmod a+r /etc/apt/keyrings/docker.gpg;
	@echo "\033[38;5;047m[DOCKER_APT_CHECKER]\033[0m: tee strat ";
	echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian  bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null;
	touch $(DOCKER_APT_CHECKER);

$(DOCKER_INSTALL_CHECKER):
	sudo apt-get update;
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;
	touch $(DOCKER_INSTALL_CHECKER);

$(DOCKER_COMPOSE_INSTALL_CHECKER):
	curl -SL https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose;
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose;
	chmod +x /usr/bin/docker-compose;
	touch $(DOCKER_COMPOSE_INSTALL_CHECKER);

set_resolv : $(NAMESERVER)
	@echo "\033[38;5;047m[set_resolv]\033[0m: set_resolv setting"

unset_reslov :
	@if [ -f ./$(NAMESERVER) ]; then rm $(NAMESERVER); fi
	$(shell (sed '/nameserver 8.8.8.8/d' /etc/resolv.conf) | cat > temp; cp temp /etc/resolv.conf ; rm temp)

set_docker_apt : set_resolv  $(DOCKER_APT_CHECKER)
	@echo "\033[38;5;047m[docker_apt]\033[0m: set_docker_apt setting"
	

docker_install : set_docker_apt $(DOCKER_INSTALL_CHECKER) docker-compose_install
	@echo "\033[38;5;047m[docker_install]\033[0m: docker_install install"

unset_docker :
	@echo "\033[38;5;196m[unset_docker]\033[0m: unset_docker unset"
	@if [ -f ./$(DOCKER_APT_CHECKER) ]; then rm $(DOCKER_APT_CHECKER); fi; \
	@if [ -f ./$(DOCKER_INSTALL_CHECKER) ]; then rm $(DOCKER_INSTALL_CHECKER); fi; \
	@if [ -f ./$(DOCKER_COMPOSE_INSTALL_CHECKER) ]; then rm $(DOCKER_COMPOSE_INSTALL_CHECKER); fi; \
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done;

docker-compose_install : set_docker_apt $(DOCKER_COMPOSE_INSTALL_CHECKER)
	@echo "\033[38;5;047m[docker-compose_install\033[0m: docker-compose install"

$(DOCKER_COMPOSE_RUN):
	@if [ $(WHOAMI) = root ]; \
	then \
		if ! [ -f $(DOCKER_COMPOSE_RUN) ]; \
		then \
			docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml up;\
		else echo "\033[38;5;048m[docker-compose_up]\033[0m: docker-compose is all ready running"; \
		fi; \
	else @echo "\033[38;5;048m[docker-compose_up]\033[0m: $(WHOAMI) is not root"; \
	fi \
	touch $(DOCKER_COMPOSE_RUN);

$(VOLUME_MARIADB):
	mkdir $(VOLUME_MARIADB);
	@echo "\033[38;5;047m[VOLUME_MARIADB]\033[0m: volume mkdir $(VOLUME_MARIADB)";

$(VOLUME_WORDPRESS):
	mkdir $(VOLUME_WORDPRESS);
	@echo "\033[38;5;047m[VOLUME_WORDPRESS]\033[0m: volume mkdir $(VOLUME_WORDPRESS)";
	
docker-compose_up : $(VOLUME_MARIADB) $(VOLUME_WORDPRESS) $(DOCKER_COMPOSE_RUN)
	@echo "\033[38;5;047m[DOCKER_COMPOSE_RUN]\033[0m: docker-compose start running";
	

docker-compose_down : 
	@if [ $(WHOAMI) = root ]; \
	then \
		if [ -f $(DOCKER_COMPOSE_RUN) ]; \
		then \
			docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml down; \
		else echo "\033[38;5;160m[docker-compose_down]\033[0m: docker-compose is not running"; \
		fi; \
		echo "\033[38;5;226m[docker-compose_down]\033[0m: docker-compose down"; \
	else echo "\033[38;5;160m[docker-compose_down]\033[0m: $(WHOAMI) is not root"; \
	fi

docker-compose_ps :
	@if [ $(WHOAMI) = root ]; \
	then \
		docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml ps; \
		echo "\033[38;5;226m[docker-compose_ps]\033[0m: docker-compose ps"; \
	else echo "\033[38;5;226m[docker-compose_ps]\033[0m: $(WHOAMI) is not root"; \
	fi

docker-compose_clean : docker-compose_down
	@if [ $(WHOAMI) = root ]; \
	then \
		docker rmi nginx:42 mariadb:42 wordpress:42; \
		echo "\033[38;5;051m[docker-compose_clean]\033[0m: docker-compose images clear"; \
	else echo "\033[38;5;051m[docker-compose_clean]\033[0m: $(WHOAMI) is not root"; \
	fi

docker-compose_fclean : docker-compose_clean
	@if [ $(WHOAMI) = root ]; \
	then \
		if [ -d $(VOLUME_MARIADB) ]; \
		then \
			rm -rf $(VOLUME_MARIADB); \
		fi \
		if [ -d $(VOLUME_WORDPRESS) ]; \
		then \
			rm -rf $(VOLUME_WORDPRESS); \
		fi \
		echo "\033[38;5;051m[docker-compose_fclean]\033[0m: docker-compose vloume data clear"; \
	else echo "\033[38;5;051m[docker-compose_fclean]\033[0m: $(WHOAMI) is not root"; \
	fi

docker-compose_re : docker-compose_fclean
docker-compose_re : docker-compose_up
	@echo "\033[38;5;123m[docker-compose_re]\033[0m: docker-compose restart~ ";