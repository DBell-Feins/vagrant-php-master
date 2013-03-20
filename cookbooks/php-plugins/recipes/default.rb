# xdebug package
php_pear "xdebug" do
  action :install
end

# php5 mysql
package "php5-mysql" do
  action :install
  notifies :restart, resources("service[apache2]"), :delayed
end

#php5 curl
package "php5-curl" do
  action :install
  notifies :restart, resources("service[apache2]"), :delayed
end

# memcached
package "memcached"

# memcache
php_pear "memcache" do
  action :install
end

# install PHPUnit
execute "pear-discover" do
  command "sudo pear config-set auto_discover 1"
end

# upgrade pear
execute "pear-upgrade" do
  command "sudo pear upgrade pear"
end

execute "phpunit" do
  command "sudo pear install pear.phpunit.de/PHPUnit"
  not_if "phpunit -v | grep 3.6"
end

# install phpDocumentor
execute "phpdocumentor" do
  command "sudo pear channel-discover pear.phpdoc.org"
end

php_pear "phpdoc/phpDocumentor-alpha" do
  action :install
end

# install git
package "git-core"

# phpMyAdmin
script "install_phpmyadmin" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  rm -rf /tmp/phpMyAdmin*

  wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/3.5.7/phpMyAdmin-3.5.7-english.tar.gz
  tar -xzvf phpMyAdmin-3.5.7-english.tar.gz

  mkdir -p /var/www/phpmyadmin
  cp -R /tmp/phpMyAdmin-3.5.7-english/* /var/www/phpmyadmin/

  EOH
  not_if "test -f /var/www/phpmyadmin"
end

# capistrano
script "install_capistrano" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  gem sources -a http://gems.github.com/
  gem install capistrano
  gem install railsless-deploy
  gem install capistrano-ext
  EOH
end