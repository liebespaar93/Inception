
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */


if (!function_exists('getenv_docker')) {
	// https://github.com/docker-library/wordpress/issues/588 (WP-CLI will load this file 2x)
	function getenv_docker($env, $default) {
		if ($fileEnv = getenv($env . '_FILE')) {
			return rtrim(file_get_contents($fileEnv), "\r\n");
		}
		else if (($val = getenv($env)) !== false) {
			return $val;
		}
		else {
			return $default;
		}
	}
}


// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', 'wordpress'));

/** Database username */
define( 'DB_USER',  getenv_docker('WORDPRESS_DB_USER', 'kyoulee'));

/** Database password */
define( 'DB_PASSWORD',  getenv_docker('WORDPRESS_DB_PASSWORD', '0000'));

/** Database hostname */
define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', 'mysql') );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );



/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         getenv_docker('WORDPRESS_AUTH_KEY', 'C2Sm;~khG@qKubV|/dB+Tk--7(Cp9A,PXSW:ac~+)cOGJNZ9Sd[BV]KK-c>p+y}a'));
define('SECURE_AUTH_KEY',  getenv_docker('WORDPRESS_SECURE_AUTH_KEY',  'rfa0@cf~x:0xQd,tach?wj~VaO5oTQl@=W#<Xn#ZAo~mup1W:X xvr{QK@7>B9:E'));
define('LOGGED_IN_KEY',    getenv_docker('WORDPRESS_LOGGED_IN_KEY',    'wGjRc)lKp-BPQS77d|rLSXc mwsdUMO^<Il93lL&6zwaT!/t{H~G|Becwj<F<61Y'));
define('NONCE_KEY',        getenv_docker('WORDPRESS_NONCE_KEY',        '92<^lZ>r*!13fon@-o5AEt`3p&!$% EJjH.F$)4jn(3]8#fp3_e2uyxx,2xm_-#E'));
define('AUTH_SALT',        getenv_docker('WORDPRESS_AUTH_SALT',        'Fzb|p~@K#0Eck(t,ma7aTO[:y4/V|@wOOA6kJ/C8VuK,l}J]_c){;5nF>C&c2LT|'));
define('SECURE_AUTH_SALT', getenv_docker('WORDPRESS_SECURE_AUTH_SALT', 'PYC+,4<_{j|mJvTUR+-kV(4RiS7v;,Zbw7qWD;ZeI4XWCjBos8hCt!}?aWwb%}@8'));
define('LOGGED_IN_SALT',   getenv_docker('WORDPRESS_LOGGED_IN_SALT',   '(uU8kOW!c1u 3Ti_LGl+#RGN}rSE-#-Yl]JA(7QV2Cj(x5S/Ww?**dSy?37[r|W%'));
define('NONCE_SALT',       getenv_docker('WORDPRESS_NONCE_SALT',       'q,) wQ^%C;Py~1K,*-G`QySg^|Q6wF&N<b*#?|C8;BlH=(U:Dt=&<Pu:<gtG!v4i'));
/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';