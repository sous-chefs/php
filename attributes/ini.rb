default['php']['ini_files']['root'] = %w(rhel fedora).include?(node.platform_family)
default['php']['ini_files']['apache2'] = false
default['php']['ini_files']['cli'] = !%w(rhel fedora).include?(node.platform_family)
default['php']['ini_files']['cgi'] = node.platform_family == 'debian'
default['php']['ini_overrides']['apache2'] = nil
default['php']['ini_overrides']['cli'] = nil
default['php']['ini_overrides']['cgi'] = nil
default['php']['ini_overrides']['root'] = nil
default['php']['ini_defaults']['PHP'] = {
  'engine' => true,
  'short_open_tag' => true,
  'asp_tags' => false,
  'precision' => 14,
  'y2k_compliance' => true,
  'output_buffering' => 4096,
  'zlib.output_compression' => false,
  'implicit_flush' => false,
  'serialize_precision' => 100,
  'allow_call_time_pass_reference' => false,
  'safe_mode' => false,
  'safe_mode_gid' => false,
  'safe_mode_allowed_env_vars' => 'PHP_',
  'safe_mode_protected_env_vars' => 'LD_LIBRARY_PATH',
  'expose_php' => true,
  'max_execution_time' => 30,
  'max_input_time' => 60,
  'memory_limit' => '128M',
  'error_reporting' => 'E_ALL & ~E_DEPRECATED',
  'display_errors' => false,
  'display_startup_errors' => false,
  'log_errors' => true,
  'log_errors_max_len' => 1024,
  'ignore_repeated_errors' => false,
  'ignore_repeated_source' => false,
  'report_memleaks' => true,
  'track_errors' => false,
  'html_errors' => false,
  'variables_order' => "GPCS",
  'request_order' => "GP",
  'register_globals' => false,
  'register_long_arrays' => false,
  'register_argc_argv' => false,
  'auto_globals_jit' => true,
  'post_max_size' => '8M',
  'magic_quotes_gpc' => false,
  'magic_quotes_runtime' => false,
  'magic_quotes_sybase' => false,
  'default_mimetype' => "text/html",
  'enable_dl' => false,
  'file_uploads' => true,
  'upload_max_filesize' => '2M',
  'max_file_uploads' => 20,
  'allow_url_fopen' => true,
  'allow_url_include' => false,
  'default_socket_timeout' => 60
}
default['php']['ini_defaults']['Pdo_mysql'] = {
  'pdo_mysql.cache_size' => 2000
}
default['php']['ini_defaults']['Syslog'] = {
  'define_syslog_variables ' => false
}
default['php']['ini_defaults']['mail function'] = {
  'SMTP' => 'localhost',
  'smtp_port' => 25,
  'mail.add_x_header' => true
}
default['php']['ini_defaults']['SQL'] = {
  'sql.safe_mode' => false
}
default['php']['ini_defaults']['ODBC'] = {
  'odbc.allow_persistent' => true,
  'odbc.check_persistent' => true,
  'odbc.max_persistent' => -1,
  'odbc.max_links' => -1,
  'odbc.defaultlrl' => 4096,
  'odbc.defaultbinmode' => 1
}
default['php']['ini_defaults']['Interbase'] = {
  'ibase.allow_persistent' => 1,
  'ibase.max_persistent' => -1,
  'ibase.max_links' => -1,
  'ibase.timestampformat' => "%Y-%m-%d %H:%M:%S",
  'ibase.dateformat' => "%Y-%m-%d",
  'ibase.timeformat' => "%H:%M:%S"
}
default['php']['ini_defaults']['MySQL'] = {
  'mysql.allow_local_infile' => true,
  'mysql.allow_persistent' => true,
  'mysql.cache_size' => 2000,
  'mysql.max_persistent' => -1,
  'mysql.max_links' => -1,
  'mysql.connect_timeout' => 60,
  'mysql.trace_mode' => false
}
default['php']['ini_defaults']['MySQLi'] = {
  'mysqli.max_persistent' => -1,
  'mysqli.allow_persistent' => true,
  'mysqli.max_links' => -1,
  'mysqli.cache_size' => 2000,
  'mysqli.default_port' => 3306,
  'mysqli.reconnect' => false
}
default['php']['ini_defaults']['mysqlnd'] = {
  'mysqlnd.collect_statistics' => true,
  'mysqlnd.collect_memory_statistics' => false,
}
default['php']['ini_defaults']['PostgresSQL'] = {
  'pgsql.allow_persistent' => true,
  'pgsql.auto_reset_persistent' => false,
  'pgsql.max_persistent' => -1,
  'pgsql.max_links' => -1,
  'pgsql.ignore_notice' => 0,
  'pgsql.log_notice' => 0,
}
default['php']['ini_defaults']['Sybase-CT'] = {
  'sybct.allow_persistent' => true,
  'sybct.max_persistent' => -1,
  'sybct.max_links' => -1,
  'sybct.min_server_severity' => 10,
  'sybct.min_client_severity' => 10,
}
default['php']['ini_defaults']['bcmath'] = {
  'bcmath.scale' => 0,
}
default['php']['ini_defaults']['Session'] = {
  'session.save_handler' => 'files',
  'session.use_cookies' => 1,
  'session.use_only_cookies' => 1,
  'session.name' => 'PHPSESSID',
  'session.auto_start' => 0,
  'session.cookie_lifetime' => 0,
  'session.cookie_path' => '/',
  'session.serialize_handler' => 'php',
  'session.gc_probability' => 1,
  'session.gc_divisor' => 1000,
  'session.gc_maxlifetime' => 1440,
  'session.bug_compat_42' => false,
  'session.bug_compat_warn' => false,
  'session.entropy_length' => 0,
  'session.cache_limiter' => 'nocache',
  'session.cache_expire' => 180,
  'session.use_trans_sid' => 0,
  'session.hash_function' => 0,
  'session.hash_bits_per_character' => 5,
  'url_rewriter.tags' => "a=href,area=href,frame=src,input=src,form=fakeentry"
}
default['php']['ini_defaults']['MSSQL'] = {
  'mssql.allow_persistent' => true,
  'mssql.max_persistent' => -1,
  'mssql.max_links' => -1,
  'mssql.min_error_severity' => 10,
  'mssql.min_message_severity' => 10,
  'mssql.compatability_mode' => false,
  'mssql.secure_connection' => false
}
default['php']['ini_defaults']['Tidy'] = {
  'tidy.clean_output' => false
}
default['php']['ini_defaults']['soap'] = {
  'soap.wsdl_cache_enabled' => 1,
  'soap.wsdl_cache_dir' => "/tmp",
  'soap.wsdl_cache_ttl' => 86400,
  'soap.wsdl_cache_limit' => 5
}
default['php']['ini_defaults']['ldap'] = {
  'ldap.max_links' => -1
}
