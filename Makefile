
ROOTDIR = $(abspath $(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

NAMESERVER=$(ROOTDIR)/nameserver_checker
DOCKER_APT_CHECKER=docker_apt_checker

VOLUME_DIR=./srcs/volume
VOLUME_MARIADB=$(VOLUME_DIR)/mariadb
VOLUME_WORDPRESS=$(VOLUME_DIR)/wordpress

ROOT	= kyoulee
WHOAMI	= $(shell whoami)

all :
	@echo "\033[38;5;047m[docker_install]\033[0m 도커를 설치 및 hosts 설정을 해준다"
	@echo "\033[38;5;047m[docker-compose_up]\033[0m compose 를 올린다"
	@echo "\033[38;5;047m[docker-compose_down]\033[0m compose 를 내린다"
	@echo "\033[38;5;047m[docker-compose_clean]\033[0m compose 의 이미지까지 삭제한다"
	@echo "\033[38;5;047m[docker-compose_fclean]\033[0m compose 의 볼륨까지 삭제한다"
	@echo "\033[38;5;047m[docker-compose_re]\033[0m 볼륨까지 삭제하고 다시 시작"
	

$(NAMESERVER):
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf;
	sudo echo "127.0.0.1       kyoulee.42.fr" >> /etc/hosts;
	@echo "\033[38;5;047m[NAMESERVER]\033[0m: add nameserver 8.8.8.8 ";
	touch $(NAMESERVER);
endif

$(DOCKER_APT_CHECKER):
	sudo apt-get update;
	sudo apt-get install -y ca-certificates curl gnupg;
	sudo install -m 0755 -d /etc/apt/keyrings;
	@echo "\033[38;5;047m[DOCKER_APT_CHECKER]\033[0m: curl https://download.docker.com/linux/debian/gpg";
	curl -4fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg;
	@echo "\033[38;5;047m[DOCKER_APT_CHECKER]\033[0m: chmod a+r start ";
	sudo chmod a+r /etc/apt/keyrings/docker.gpg;
	@echo "\033[38;5;047m[DOCKER_APT_CHECKER]\033[0m: tee strat ";
	echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian  bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null;
	touch $(DOCKER_APT_CHECKER);

set_resolv : $(NAMESERVER)
	@echo "\033[38;5;047m[set_resolv]\033[0m: set_resolv setting"

unset_reslov :
	@if [ -f ./$(NAMESERVER) ]; then rm $(NAMESERVER); fi
	$(shell (sed '/127.0.0.1       kyoulee.42.fr/d' /etc/hosts) | cat > temp; cp temp /etc/hosts ; rm temp);
	$(shell (sed '/nameserver 8.8.8.8/d' /etc/resolv.conf) | cat > temp; cp temp /etc/resolv.conf ; rm temp);

set_docker_apt : set_resolv  $(DOCKER_APT_CHECKER)
	@echo "\033[38;5;047m[docker_apt]\033[0m: set_docker_apt setting"
	

docker_install : set_docker_apt docker-compose_install
	sudo apt-get update;
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin;
	@echo "\033[38;5;047m[docker_install]\033[0m: docker_install install"

docker_uninstall :
	@echo "\033[38;5;196m[unset_docker]\033[0m: unset_docker unset";
	@if [ -f ./$(DOCKER_APT_CHECKER) ]; then rm $(DOCKER_APT_CHECKER); fi;
	for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done;

docker-compose_install : set_docker_apt
	curl -SL https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose;
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose;
	chmod +x /usr/bin/docker-compose;
	@echo "\033[38;5;047m[docker-compose_install]\033[0m: docker-compose install";


$(VOLUME_DIR):
	mkdir -p $(VOLUME_DIR);
	@echo "\033[38;5;047m[VOLUME_DIR]\033[0m: volume mkdir $(VOLUME_DIR)";

$(VOLUME_MARIADB): $(VOLUME_DIR)
	mkdir -p $(VOLUME_MARIADB);
	@echo "\033[38;5;047m[VOLUME_MARIADB]\033[0m: volume mkdir $(VOLUME_MARIADB)";

$(VOLUME_WORDPRESS): $(VOLUME_DIR)
	mkdir -p $(VOLUME_WORDPRESS);
	@echo "\033[38;5;047m[VOLUME_WORDPRESS]\033[0m: volume mkdir $(VOLUME_WORDPRESS)";

docker-compose_up : $(VOLUME_MARIADB) $(VOLUME_WORDPRESS)
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml up -d;
	@echo "\033[38;5;048m[docker-compose_up]\033[0m: docker-compose start running";
endif

docker-compose_down : 
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml down;
	@echo "\033[38;5;160m[docker-compose_down]\033[0m: docker-compose down";
endif

docker-compose_ps :
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml ps;
	@echo "\033[38;5;226m[docker-compose_ps]\033[0m: docker-compose ps";
endif

docker-compose_clean : docker-compose_down
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	@if ! [ -z $(shell docker ps --filter status=exited -q) ]; then \
		docker rm $(shell docker ps --filter status=exited -q); \
	fi
	docker rmi nginx:42 mariadb:42 wordpress:42;
	@echo "\033[38;5;189m[docker-compose_clean]\033[0m: docker-compose images clear";
endif

docker-compose_fclean : docker-compose_clean
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	@if [ -d $(VOLUME_MARIADB) ]; then rm -rf $(VOLUME_MARIADB); fi;
	@if [ -d $(VOLUME_WORDPRESS) ]; then rm -rf $(VOLUME_WORDPRESS); fi;
	@if [ -d $(VOLUME_DIR) ]; then rm -rf $(VOLUME_DIR); fi;
	docker volume rm v-db v-wordpress
	@echo "\033[38;5;051m[docker-compose_fclean]\033[0m: docker-compose volume data clear";
endif

docker-compose_re : docker-compose_up
docker-compose_re : docker-compose_fclean
	@echo "\033[38;5;123m[docker-compose_re]\033[0m: docker-compose restart~ ";


docker-compose_up_nodaemonize :  $(VOLUME_MARIADB) $(VOLUME_WORDPRESS) $(DOCKER_42_IMAGE)
ifneq "$(WHOAMI)" "$(ROOT)"
	@echo "\033[38;5;196m[docker-compose_up_nodaemonize]\033[0m: $(WHOAMI) is not $(ROOT)";
else
	@echo "\033[38;5;048m[docker-compose_up_nodaemonize]\033[0m: docker-compose start running";
	docker-compose -f $(ROOTDIR)/srcs/docker-compose.yml up;
endif