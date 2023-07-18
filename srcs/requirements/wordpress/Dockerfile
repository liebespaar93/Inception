# syntax=docker/dockerfile:1

FROM debian:bookworm-slim as wordpress-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y whiptail dialog ca-certificates curl tar

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y php8.2-fpm \
    && ln -sf /dev/stderr /var/log/php8.2-fpm.log

COPY ./conf /conf
COPY ./tools /tools

VOLUME /var/www/wordpress

WORKDIR /var/www/wordpress

RUN chmod +x /tools/entrypoint.sh

EXPOSE 9000

ENTRYPOINT [ "/tools/entrypoint.sh" ]

CMD ["/usr/sbin/php-fpm8.2", "--nodaemonize"]