# syntax=docker/dockerfile:1

FROM debian:bookworm-slim as wordpress-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y whiptail dialog ca-certificates curl tar

RUN set -eux \
	&& apt-get install -y php8.2-fpm

COPY ./conf /conf
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

WORKDIR /var/www/html

CMD ["tail", "-f", "/dev/null"]

#curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-6.2.tar.gz";
#tar -xzf wordpress.tar.gz -C /usr/src/; \
#rm wordpress.tar.gz; 
#chown -R www-data:www-data /usr/src/wordpress

