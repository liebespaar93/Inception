# syntax=docker/dockerfile:1

FROM debian:bookworm-slim as mariadb-kyoulee

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends gosu sudo;

RUN set -eux \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends mariadb-server \
	&& mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld;

VOLUME /var/lib/mysql

COPY ./tools/. /tools/.
COPY ./conf/. /conf/.

# RUN chmod +x /tools/entrypoint.sh
# ENTRYPOINT [ "/tools/entrypoint.sh" ]
CMD ["tail", "-f", "/dev/null"]
# CMD ["gosu", "mysql", "mysqld_safe"]