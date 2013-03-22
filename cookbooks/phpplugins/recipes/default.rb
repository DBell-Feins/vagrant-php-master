require_recipe "apache2"
require_recipe "apache2::mod_php5"
require_recipe "php"

require 'fileutils'

#php5 xsl
package "php5-xsl" do
  action :install
end

# xdebug package
package "php5-xdebug" do
  action :install
end

# memcached
package "memcached"
# memcache - might be able to get this directly from the php cookbook
#php_pear "memcache" do
  #action :install
#end

# Set up PHP packages.
php_pear_channel "pear.php.net" do
  action :update
end

phpunit = php_pear_channel "pear.phpunit.de" do
  action :discover
end

php_pear_channel "pear.phpdoc.org" do
  action :discover
end

# Run PEAR upgrade
php_pear "PEAR" do
  action    :upgrade
  options   "--force"
end

# phpDocumentor
script 'install-PhpDocumentor' do
  interpreter 'bash'
  user        'root'
  code <<-EOS
  pear config-set auto_discover 1
  pear install phpdoc/phpDocumentor-alpha
  EOS
end

# install PHPUnit
php_pear "PHPUnit" do
  channel          phpunit.channel_name
  preferred_state  "beta"
  action           :install
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

service 'apache2' do
  action :restart
end
