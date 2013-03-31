# We need yaml for reading config files and rbconfig for testing the host operating system
require 'yaml'
require 'rbconfig'

# We need deep_merge so let's grab activesupport unless we already have it
`gem install activesupport --conservative` unless `gem list`.lines.grep(/^activesupport \(.*\)/).length > 0
require 'active_support/core_ext/hash/deep_merge'

# Test if the host is a Windows box. If not, we'll set synced folders to use NFS for a (hopeful) performance increase
IS_WINDOWS = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/) ? true : false

# Set config folder and default config file path
CONFIG_PATH = File.join(Dir.pwd, "config")
DEFAULT_CONFIG = File.join(CONFIG_PATH, 'default.yml')

# Read default config file
if File.exist?(DEFAULT_CONFIG) then
  begin
    base_config = YAML.load_file(DEFAULT_CONFIG)
  rescue Errno::ENOENT
    abort("Failed to load the default configuration file.")
  end
end

# Loop all other yaml files in the config directory and deep merge them into one hash
config_files = {}
Dir.foreach(CONFIG_PATH) do |item|
    next if item == '.' or item == '..' or item == 'default.yml'
    if File.extname(item) == '.yml' then
      local = YAML.load_file(File.join(CONFIG_PATH, item))
      config_files = config_files.deep_merge(local)
    end
end

# Deep merge default config with other config files (assuming they exist)
user_config = (config_files.length == 0 && base_config) || base_config.deep_merge(config_files)

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

      chef.json.merge(user_config)
  end
end