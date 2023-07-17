# syntax=docker/dockerfile:1

FROM debian:bookworm-slim as wordpress-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y whiptail dialog ca-certificates curl tar

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y php8.2-fpm

COPY ./conf /conf
COPY ./tools /tools

VOLUME /var/www/html

WORKDIR /var/www/html

RUN chmod +x /tools/entrypoint.sh

ENTRYPOINT [ "/tools/entrypoint.sh" ]

CMD ["/usr/sbin/php-fpm8.2", "--nodaemonize"]