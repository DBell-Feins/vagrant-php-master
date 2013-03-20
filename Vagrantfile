# -*- mode: ruby -*-
# vi: set ft=ruby :

# test if the host is a Windows box. If not, we'll set synced folders to use NFS for
# a (hopeful) performance increase
require 'rbconfig'
IS_WINDOWS = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/) ? true : false

Vagrant.configure("2") do |config|
  # Box
  config.vm.box = "precise32"

  # Box URL
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Shared folder
  config.vm.synced_folder "www", "/home/vagrant/www", :nfs => !IS_WINDOWS

  # Allows symlinks to be created in the shared folder.
  config.vm.provider :virtualbox do |v|
    v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/www", "1"]
  end

  # Forwarded ports
  config.vm.network :hostonly, "33.33.33.10"
  config.vm.network :forwarded_port, host: 3000, guest: 80 # apache

  # Provisioning with Chef
  config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"
      chef.log_level = :debug
      chef.add_role("base")
      chef.add_role("amp")
      chef.add_role("extras")

      #chef.add_recipe "apt"
      #chef.add_recipe "build-essential"
      #chef.add_recipe "openssl"
      #chef.add_recipe "git"
      #chef.add_recipe "nodejs"
      #chef.add_recipe "npm"

      #chef.add_recipe "apache2"
      #chef.add_recipe "mysql"
      #chef.add_recipe "php"
      #chef.add_recipe "xml"

      #chef.add_recipe "lesscss"
      #chef.add_recipe "uglifyjs"

      #chef.add_recipe "extras"

      chef.json = {
        "extras" => {
          "hostname" => "project.local",
          "aliases" => ["project-alias.local"],
          "set_env" => "local"
        },
        "mysql" => {
          "server_root_password" => "root"
        }
      }
  end
end