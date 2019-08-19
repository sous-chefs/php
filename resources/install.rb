property :method, String, name_property: true, default: 'package'
property :version, String, default: '7.3.8'
property :download_url, String, default: "https://www.php.net/distributions/php-#{version}.tar.gz"
property :shasum, String, default: '31af3eff3337fb70733c9b02a3444c3dae662ecab20aeec7fdc3c42e22071490'

# Configuration options
property :prefix, String, default: '/usr/local'
property :lib_dir, default: lazy { default_php_lib_dir }
property :config_file_path, default: lazy { default_php_conf_dir }
property :with_config_file_scan_dir, default: lazy { default_php_ext_conf_dir }
property :with_pear, [true, false], default: true
property :fpm_user, [true, false], default: true
property :fpm_group, [true, false], default: true
property :with_zlib, [true, false], default: true
property :with_openssl, [true, false], default: true
property :with_kerberos, [true, false], default: true
property :with_bz2, [true, false], default: true
property :with_curl, [true, false], default: true
property :with_gd, [true, false], default: true
property :with_gettext, [true, false], default: true
property :with_gmp, [true, false], default: true
property :with_mhash, [true, false], default: true
property :with_iconv, [true, false], default: true
property :with_imap, [true, false], default: true
property :with_imap_ssl, [true, false], default: true
property :with_xmlrpc, [true, false], default: true
property :with_mcrypt, [true, false], default: true
property :enable_fpm, [true, false], default: true
property :enable_sockets, [true, false], default: true
property :enable_soap, [true, false], default: true
property :enable_ftp, [true, false], default: true
property :enable_zip, [true, false], default: true
property :enable_exif, [true, false], default: true
property :enable_mbstring, [true, false], default: true
property :enable_gd_native_ttf, [true, false], default: true
