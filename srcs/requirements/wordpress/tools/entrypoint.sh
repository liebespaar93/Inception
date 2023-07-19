#!/bin/bash

wordpress_log() {
	local type="$1"; shift
	local color="$1"; shift
	printf '[%s] \033[38;5;%sm[%s]\033[0m: %s\n' "$(date +%d/%b/%Y:%H:%M:%S) +0000" "$color" "$type" "$*"
}
wordpress_note() {
	wordpress_log NOTE "008" "$@"
}
wordpress_warn() {
	wordpress_log WARNNING "227" "$@" >&2
}
wordpress_error() {
	wordpress_log ERROR "196" "$@" >&2
}

wordpress_ready() {
	wordpress_log READY "082" "$@"
}
wordpress_service() {
	wordpress_log SERVICE "165" "$@"
}

if [ -z $USER ]
then
	wordpress_warn "NO USER env"
	USER=kyoulee
fi
ft_php-fpm_set()
{
	if ! [ -f /etc/php/8.2/fpm/pool.d/www.conf ] || ! [ -f /conf/www.conf ]
	then
		wordpress_error "www.conf not found"
		exit 1;
	fi
	cp /conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
	chmod +x /etc/php/8.2/fpm/pool.d/www.conf
	wordpress_ready "www.conf Copy Done";

	if ! [ -f /etc/php/8.2/fpm/php-fpm.conf ] || ! [ -f /conf/php-fpm.conf ]
	then
		wordpress_error "php-fpm.conf not found"
		exit 1;
	fi
	cp /conf/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
	chmod +x /etc/php/8.2/fpm/php-fpm.conf
	wordpress_ready "php-fpm.conf Copy Done";

	if ! [ -f /etc/php/8.2/fpm/php.ini ] || ! [ -f /conf/php.ini ]
	then
		wordpress_error "php.ini not found"
		exit 1;
	fi
	cp /conf/php.ini /etc/php/8.2/fpm/php.ini
	chmod +x /etc/php/8.2/fpm/php.ini
	wordpress_ready "fpm php.ini Copy Done";

	if ! [ -f /etc/php/8.2/cli/php.ini ] || ! [ -f /conf/php.ini ]
	then
		wordpress_error "php.ini not found"
		exit 1;
	fi
	cp /conf/php.ini /etc/php/8.2/cli/php.ini
	chmod +x /etc/php/8.2/cli/php.ini
	wordpress_ready "cli php.ini Copy Done";

}

ft_wordpress_set()
{
	if ! [ -f index.php ]
	then
		wordpress_note "download https://wordpress.org/wordpress-6.2.tar.gz"
		curl --silent -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-6.2.tar.gz"
		if ! [ -f wordpress.tar.gz ] 
		then
			wordpress_error "No file wordpress.tar.gz"
			exit 1
		fi
		wordpress_note "tar wordpress.tar.gz"
		tar -xzf wordpress.tar.gz -C /var/www/wordpress --strip 1 
		rm wordpress.tar.gz
	fi
	chown -R www-data /var/www/wordpress; 
	chmod -R 775 /var/www/wordpress; 
	wordpress_note "chown -R www-data:www-data /var/www/wordpress"
	chown -R www-data:www-data wp-content;
	chmod -R 1777 wp-content
	wordpress_note "chown -R www-data:www-data wp-content"
	wordpress_note "chmod -R 1777 wp-content"
	chown -R www-data /usr/lib/php
	chmod -R 1777 /usr/lib/php/20220829/mysqli.so

	wordpress_ready "All ready wordpress"
}

ft_web_config_set()
{
	if ! [ -f /conf/wp-config.php ]
	then
		wordpress_error "www.conf not found"
		exit 1;
	fi
	cp /conf/wp-config.php /var/www/wordpress/wp-config.php
	chmod +x /var/www/wordpress/wp-config.php
	wordpress_ready "config.php Copy Done";
}

_main()
{
	ft_php-fpm_set
	ft_wordpress_set
	# ft_web_config_set
	wordpress_service "wordpresss php-fpm8.2 server on"
}

_main

exec "$@"
