
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

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'kyoulee' );

/** Database password */
define( 'DB_PASSWORD', '0000' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

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
define('AUTH_KEY',         '.}|5=KcX*r+/)&c<gB[1a+E|/`6ORRkg?=>@hi+I-N.&#I._`:Jy36J~=s/:sG%F');
define('SECURE_AUTH_KEY',  'c.@2{<bqqBw_d|I@ hvoB]L[*1X9X{Uuw!Ap;O|OiJr0;Mkbxrx<;F,S+3w=.Wb%');
define('LOGGED_IN_KEY',    ',uW&_/w_mz5M-PFEj&J3X{FxgWf>O#V>QPnmr1vm7kg$S(KYa03(H? $ZgIcg`yy');
define('NONCE_KEY',        'qEPQBtfw?K?K%^1$HfCqdA+f<%0R6#+t_>F#O|Vc|W1*(is1W}u ;&?Rf}e@@-1/');
define('AUTH_SALT',        'TNwm9iqr(YK7-O6@LG--pkdrA|Y2V^+4lXfU?jd!emyu%3-%A.&l&|eR+$Nuk&Ks');
define('SECURE_AUTH_SALT', 'WA`/FAAYd~*-6ElZ+xDpn-qLk{7l?i4+Bw-Fsl{:{ey4;~fA|T++:OGQ1&Mcb{tY');
define('LOGGED_IN_SALT',   'sc~*G2yTbG|tF8pKSV0VHWMtQ=-0HzA/daZO=-v&lk@;yZR3&v]{t*G9JLal{F?^');
define('NONCE_SALT',       'jMu;>|VS)|@0W)[0hDOU~&GFf;oXAY~7}h_kw8-U/X_.GXFk6!^4KQBBi5@FON~o');

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