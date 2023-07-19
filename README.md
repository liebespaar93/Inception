# Inception
# 주의!!  debian bullseye 기준입니다
# 1. Ssh port 설정  [ Port 22 경우 skip ]
echo "Port 22" > /etc/ssh/sshd_config.d/cluster.conf
service ssh restart
su 

# 2. 기본 설치 
su 
password: 입력
apt-get update
apt-get install -y sudo git make


### makefile 자동화 or 하위 따라가기
git clone https://github.com/liebespaar93/Inception.git


# 3. 인터넷 설정
 /etc/resolv.conf 변경
nameserver 10.51.1.253 -> nameserver 8.8.8.8

echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# 4. docker 삭제
- 삭제
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt-get remove $pkg; done

# 5. docker 설치
# - apt에 download.docker 파일 목록 추가 

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

# - docker build 설치

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# - docker compose plugin





# php 테스트

https://easyengine.io/tutorials/php/directly-connect-php-fpm/


SCRIPT_NAME=/index.php \
SCRIPT_FILENAME=/index.php \
DOCUMENT_ROOT=/ \
REQUEST_METHOD=GET \
cgi-fcgi -bind -connect 127.0.0.1:9000


# network 확인
apt install net-tools
sudo netstat -ltup


# socket 확인
socat - UNIX-CONNECT:/run/mysqld/mysqld.sock