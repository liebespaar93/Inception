#!/bin/bash

######
# loger
######

mysql_log() {
	local type="$1"; shift
	local color="$1"; shift
	printf '%s \033[38;5;%sm[%s]\033[0m: %s\n' "$(date --rfc-3339=seconds)" "$color" "$type" "$*"
}
mysql_note() {
	mysql_log Note "008" "$@"
}
mysql_warn() {
	mysql_log Warn "227" "$@" >&2
}
mysql_error() {
	mysql_log ERROR "196" "$@" >&2
}

mysql_ready() {
	mysql_log READY "082" "$@"
}
mysql_destory() {
	mysql_log DESTROY "208" "$@"
}
mysql_env() {
	mysql_log ENV "045" "$@"
}
mysql_service() {
	mysql_log SERVICE "165" "$@"
}

######
# check user
######


if [ -z $USER ]
then
	mysql_warn "NO USER env"
	USER=kyoulee
fi


######
# check mariadb
######


ft_on_mariadb()
{
	if ! [ -f /etc/mysql/mariadb.conf.d/50-server.cnf ] || ! [ -f /conf/50-server.cnf ]
	then
		mysql_error "50-server.cnf not found"
		exit 1;
	fi
	cp /conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
	chmod +x /etc/mysql/mariadb.conf.d/50-server.cnf
	mysql_ready "50-server.cnf -> /etc/mysql/mariadb.conf.d/50-server.cnf"

	if ! [ -f /etc/mysql/mariadb.cnf ] || ! [ -f /conf/mariadb.cnf ]
	then
		mysql_error "mariadb.cnf not found"
		exit 1;
	fi
	cp /conf/mariadb.cnf /etc/mysql/mariadb.cnf
	chmod +x /etc/mysql/mariadb.cnf
	mysql_ready "/conf/mariadb.cnf -> etc/mysql/mariadb.cnf"


	if ! [ -f /etc/mysql/my.cnf ] || ! [ -f /conf/my.cnf ]
	then
		mysql_error "my.cnf not found"
		exit 1;
	fi
	cp /conf/my.cnf /etc/mysql/my.cnf
	chmod +x /etc/mysql/my.cnf
	mysql_ready "/conf/my.cnf -> etc/mysql/my.cnf"

}

######
# env setting
######


mysql_get_config() {
	local conf="$1"; shift
	mariadb --verbose --help 2>/dev/null \
		| awk -v conf="$conf" '$1 == conf && /^[^ \t]/ { sub(/^[^ \t]+[ \t]+/, ""); print; exit }'
}

_mariadb_file_env() {
	local var="$1"; shift
	local maria="MARIADB_${var#MYSQL_}"
	file_env "$var" "$@"
	file_env "$maria" "${!var}"
	if [ "${!maria:-}" ]; then
		export "$var"="${!maria}"
		mysql_env "$var=${!maria}"
	fi
}

file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		mysql_error "Both $var and $fileVar are set (but are exclusive)"
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	mysql_env "$var=$val"
	unset "$fileVar"
}

ft_mariadb_set_env() {
	declare -g DATADIR SOCKET PORT
	DATADIR="/var/lib/mysql"
	SOCKET="$(mysql_get_config 'socket')"
	PORT="$(mysql_get_config 'port')"
	mysql_note DATADIR=$DATADIR
	mysql_note SOCKET=$SOCKET
	mysql_note PORT=$PORT

	# Initialize values that might be stored in a file
	_mariadb_file_env 'MYSQL_ROOT_HOST' '%'
	_mariadb_file_env 'MYSQL_DATABASE'
	_mariadb_file_env 'MYSQL_USER'
	_mariadb_file_env 'MYSQL_PASSWORD'
	_mariadb_file_env 'MYSQL_ROOT_PASSWORD'

	# env variables related to master
	file_env 'MARIADB_MASTER_HOST'
	file_env 'MARIADB_MASTER_PORT' 3306
}

ft_verify_minimum_env() {
	if [ -z "$MYSQL_DATABASE" ]; then
		mysql_error "MYSQL_DATABASE EMPTY"
		exit 1
	fi
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		mysql_error "MYSQL_ROOT_PASSWORD EMPTY"
		exit 1
	fi
	if [ -z "$MYSQL_USER" ]; then
		mysql_error "MYSQL_USER EMPTY"
		exit 1
	fi
	if [ -z "$MYSQL_PASSWORD" ]; then
		mysql_error "MYSQL_PASSWORD EMPTY"
		exit 1
	fi
	if [ -z "$MARIADB_MASTER_PORT" ]; then
		mysql_warn "MARIADB_MASTER_PORT = 3306"
	fi
}


######
# temp server 
######

ft_sql_exec_client() {
	mariadb --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" "$@"
}

docker_process_sql() {
	if [ '--dont-use-mysql-root-password' = "$1" ]; then
		shift
		MYSQL_PWD='' ft_sql_exec_client "$@"
	else
		MYSQL_PWD=$MARIADB_ROOT_PASSWORD ft_sql_exec_client "$@"
	fi
}

ft_temp_server_start() {
	# mysql_note "Starting MariaDB database server: mariadb"
	# service mariadb start > /dev/null
 	mysqld_safe -uroot --skip-networking --default-time-zone=SYSTEM --socket="${SOCKET}" --wsrep_on=OFF --expire-logs-days=0 \
		--loose-innodb_buffer_pool_load_at_startup=0 \
		& declare -g MARIADB_PID 
	MARIADB_PID=$!
	mysql_ready "[PID $MARIADB_PID] temp server Ready"
	mysql_note "Waiting for server startup"
	local i
	for i in {20..0}; do
		mysql_note "wait mysqld_safe connect.."
		if docker_process_sql --dont-use-mysql-root-password --database=mysql <<<'SELECT 1' &> /dev/null; then
			break
		fi
		sleep 1
	done
	if [ "$i" = 0 ]; then
		mysql_error "Unable to start server."
		exit 1
	fi

	mysql_service "[PID $MARIADB_PID] temp server Done Connect server ON"
}

ft_temp_server_stop() {
	killall -15 mariadbd
	kill "$MARIADB_PID"
	wait "$MARIADB_PID"
	mysql_destory "[PID $MARIADB_PID] temp server Clear"
}


######
# set up data-base
######
ft_set_database() {

	mysql_note "docker_setup_db"
	docker_process_sql <<-EOSQL
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON  *.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
	EOSQL
	mysql_ready "'$MYSQL_USER'@'%' user Created $MYSQL_PASSWORD"

	docker_process_sql <<-EOSQL
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	EOSQL
	mysql_ready "create database $MYSQL_DATABASE"

	ft_sql_exec_client <<-EOSQL
	set password for 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD');
	flush privileges;
	EOSQL
	mysql_ready "'root'@'localhost' user change password $MYSQL_ROOT_PASSWORD"
}
_main()
{
	mysql_note "entrypoint _main() "
	ft_on_mariadb
	ft_mariadb_set_env
	ft_verify_minimum_env
	chown -R mysql /var/lib/mysql /var/run/mysqld;
	chown -R root  /var/lib/mysql /var/run/mysqld;
	chmod 777 /var/run/mysqld;
	# ft_temp_server_start
	# ft_set_database
	# ft_temp_server_stop
	mysql_ready "mysql health check done!"
	mysql_service "mysql start gosu mysql mysqld_safe server on"
}

_main

exec "$@"
