# syntax=docker/dockerfile:1

FROM debian:bullseye-slim as wordpress-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y whiptail dialog ca-certificates curl tar

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y \
	wget \
	curl \
	php7.4-fpm \
	php7.4-mysql \
	php7.4-curl \
    && ln -sf /dev/stderr /var/log/php7.4-fpm.log

COPY ./conf /conf
COPY ./tools /tools

VOLUME /var/www/wordpress

WORKDIR /var/www/wordpress

RUN chmod +x /tools/entrypoint.sh
ENTRYPOINT [ "/tools/entrypoint.sh" ]

CMD ["php-fpm7.4" ,"--pid", "/run/php/php7.4-fpm.pid", "--nodaemonize"]