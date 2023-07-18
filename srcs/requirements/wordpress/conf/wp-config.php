
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
define( 'DB_NAME', getenv_docker('WORDPRESS_DB_NAME', 'wordpress') );

/** Database username */
define( 'DB_USER', getenv_docker('WORDPRESS_DB_USER', 'example username') );

/** Database password */
define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', 'example password') );

/** Database hostname */
define( 'DB_HOST', getenv_docker('WORDPRESS_DB_HOST', 'mysql') );
// define( 'DB_HOST', "mariadb:3306" );

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
define('AUTH_KEY',         '9s>WF]NP}.}<xKf(f&,obr<EhSYcK9U0YB4`|9AT/+^`-0*CsmJgHTNDkII8Rm#e');
define('SECURE_AUTH_KEY',  'Jv-_ptY0!@mJK+MNGP):w[C,z~x%,3oWol*jK0O1m=a12lj^+p{@hLaTx)U/,M^(');
define('LOGGED_IN_KEY',    'v+=6] -:fH@9)n-l%,|X<(=K+Q^A!/)MF]<=,5~CvSL=,@~S7hun08T;dtpI~4=[');
define('NONCE_KEY',        'uE%%[B_C;A/4gm|Z}M0nZ2NP+GTT8|fp J=fKXmTyD4RWR&eZ>S ~c  ?W1h;L7#');
define('AUTH_SALT',        '8_s-|}s.W)V7s{xlxfXP.)bh_EM19*.`]d>fHP#g}*tuU[Ya.rp@lY^h|w{Wu!R^');
define('SECURE_AUTH_SALT', '=^AulV;L^RqV;a5=[-h0il!JJHN**&Ll yW.GL}q8S-O~}BURmF*OA%g`buzr(#x');
define('LOGGED_IN_SALT',   '*pLdO;{rE&T>s|;R% `rZ.#{.k!C:6fGkiOd-:mqNu`e@#)q1_+@5)}vpHjT8=<a');
define('NONCE_SALT',       '{@TMF|.g;ogr4Pfa{zJ=~0og8;[FD}q4ggo.t<xUEYj4Zj_sYZ=Sp,W^t[6bYh)#');
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