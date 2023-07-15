# syntax=docker/dockerfile:1

FROM debian:bookworm-slim as mariadb-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends gosu;

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends mariadb-server;

VOLUME /var/lib/mysql

COPY ./tools/. /tools/.
COPY ./conf/. /conf/.

EXPOSE 3306

RUN chmod +x /tools/entrypoint.sh
ENTRYPOINT [ "/tools/entrypoint.sh" ]
# CMD ["tail", "-f", "/dev/null"]

CMD ["mariadb"]