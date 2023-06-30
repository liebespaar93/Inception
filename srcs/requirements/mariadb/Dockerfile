# syntax=docker/dockerfile:1

FROM debian:bookworm-slim AS mariadb

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		gosu \
		mariadb-server \

VOLUME /var/lib/mysql

COPY healthcheck.sh /usr/local/bin/healthcheck.sh
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mariadbd"]

#service mariadb start