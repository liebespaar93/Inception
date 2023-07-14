# syntax=docker/dockerfile:1

FROM debian:bookworm-slim as nginx-kyoulee


RUN set -aux \
	&& apt-get update \
	&& apt install -y openssl \
	&& openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
		-out /etc/ssl/certs/kyoulee.crt  -keyout /etc/ssl/private/kyoulee.key \
		-subj "/C=KR/ST=GangNam/L=Seoul/O=42Seoul/OU=Cadet/CN=kyoulee.kr";


RUN set -eux \
	&& apt-get update \
	&& apt-get install -y nginx=1.22.*;
	# && update-rc.d -f nginx disable;

COPY ./conf/default /etc/nginx/sites-available/default
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
EXPOSE 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
