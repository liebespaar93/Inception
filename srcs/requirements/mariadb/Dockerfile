# syntax=docker/dockerfile:1

FROM debian:bullseye-slim as mariadb-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends mariadb-server-10.5 \
	&& mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld;

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends gosu sudo;

VOLUME /var/lib/mysql

COPY ./tools/. /tools/.
COPY ./conf/. /conf/.

RUN chmod +x /tools/entrypoint.sh
ENTRYPOINT [ "/tools/entrypoint.sh" ]


CMD ["gosu", "mysql", "mysqld"]