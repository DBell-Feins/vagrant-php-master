# overwrite default php.ini with custom one
template "/etc/php5/conf.d/custom.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end

# xdebug template
template "/etc/php5/conf.d/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode 0644
end

# disable default apache site
execute "disable-default-site" do
  command "sudo a2dissite default"
end

# configure apache project vhost
web_app "project" do
  template "project.conf.erb"

  server_name node['phpapacheconf']['hostname']
  docroot node['phpapacheconf']['docroot']
  set_env node['phpapacheconf']['set_env']
end

script "phpinfo" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
  rm -rf /tmp/phpinfo*
  mkdir -p /var/www/phpinfo
  EOH
  not_if "test -f /var/www/phpinfo"
end

template "/var/www/phpinfo/index.php" do
  source "index.php.erb"
  owner "root"
  group "root"
  mode 0755
end

service 'apache2' do
  action :restart
end
