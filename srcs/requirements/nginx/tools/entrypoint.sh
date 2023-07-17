#!/bin/bash

nginx_log() {
	local type="$1"; shift
	local color="$1"; shift
	printf '[%s] \033[38;5;%sm[%s]\033[0m: %s\n' "$(date +%d/%b/%Y:%H:%M:%S) +0000" "$color" "$type" "$*"
}
nginx_note() {
	nginx_log NOTE "008" "$@"
}
nginx_warn() {
	nginx_log WARNNING "227" "$@" >&2
}
nginx_error() {
	nginx_log ERROR "196" "$@" >&2
}

nginx_ready() {
	nginx_log READY "082" "$@"
}
nginx_service() {
	nginx_log SERVICE "165" "$@"
}

if [ -z $USER ]
then
	nginx_warn "NO USER env"
	USER=kyoulee
fi

ft_nginx_set()
{
	if ! [ -d /etc/nginx ]
	then
		nginx_error "nginx is fail"
		return 1
	fi
	nginx_service "[SERVICE] nginx is on"
	nginx_note "Welcome $USER"
	nginx_note "[$HOSTNAME] is all ready nginx"

	if ! [ -f /etc/ssl/certs/kyoulee.crt ]
	then
		nginx_error "[SSL] SSL CRT is fail"
		return 2
	fi
	nginx_ready "[SERVICE] SSL CRT is READY"
	nginx_note /etc/ssl/certs/kyoulee.crt

	if ! [ -f /etc/ssl/private/kyoulee.key ]
	then
		nginx_error "[SSL] SSL key is fail"
		return 2
	fi
	nginx_ready "[SERVICE] SSL KEY is READY"
	nginx_note "/etc/ssl/private/kyoulee.key"

	nginx_service "SSL on"
}

_main()
{
	ft_nginx_set
}

_main

exec "$@"
