name          "phpapacheconf"
maintainer        "Dave Bell-Feins"
maintainer_email  "David_Bell-Feins@abtassoc.com"
license           "Apache 2.0"
description       "Installs basic PHP, Xdebug, and Apache configurations from templates"
version           "1.0"
recipe            "php-apache-conf", "Installs all configurations"

depends "apache2"
depends "php"
depends "phpplugins"

attribute "phpapacheconf/hostname",
  :display_name => "Apache server name",
  :description => "The ServerName directive sets the request scheme, hostname and port that the server uses to identify itself. - http://httpd.apache.org/docs/2.2/mod/core.html#servername",
  :default => "local.dev"

attribute "phpapacheconf/set_env",
  :display_name => "Server environment",
  :description => "A keyword that describes the server environment. Can be accessed via PHP by calling getenv('APPLICATION_ENV')",
  :type => "string",
  :choice => [
    'development',
    'testing',
    'production' ],
  :default => "development"

attribute "phpapacheconf/docroot",
  :display_name => "The server document root",
  :description => "This directive sets the directory from which httpd will serve files. - http://httpd.apache.org/docs/2.2/mod/core.html#documentroot",
  :default => "/home/vagrant/www"