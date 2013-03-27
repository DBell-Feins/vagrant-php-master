# -*- mode: ruby -*-
# vi: set ft=ruby :

# test if the host is a Windows box. If not, we'll set synced folders to use NFS for
# a (hopeful) performance increase
require 'rbconfig'
IS_WINDOWS = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/) ? true : false

# use YAML to separate config files from the Vagrantfile
require 'yaml'

# Read all yaml files from config directory
if File.directory?(File.join(Dir.pwd, "config")) == true
  CONFIG_PATH = File.join(Dir.pwd, "config")
  begin
    base_config = YAML.load_file(File.join(CONFIG_PATH, 'default.yml'))
  rescue Errno::ENOENT
    puts "Unable to load config file, exiting..."
    exit
  end
  base_config.to_json

  Dir.foreach(CONFIG_PATH) do |item|
    next if item == '.' or item == '..' or item == 'default.yml'
      if File.extname(item) == '.yml' then
        config = YAML.load_file(item)
      end
  end
end

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
  config.vm.network :forwarded_port, host: 3000, guest: 80 # apache
  config.vm.network :forwarded_port, host: 3333, guest: 3306 # mysql

  # Provisioning with Chef
  config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"
      chef.add_role("base")
      chef.add_role("amp")
      chef.add_role("extras")

      chef.json.merge(base_config)
  end
end