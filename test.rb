# We need yaml for reading config files and rbconfig for testing the host operating system
require 'yaml'
require 'ap'

# We need deep_merge so let's grab activesupport unless we already have it
`gem install activesupport --conservative` unless `gem list`.lines.grep(/^activesupport \(.*\)/).length > 0
require 'active_support/core_ext/hash/deep_merge'

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
config = (config_files.length == 0 && base_config) || base_config.deep_merge(config_files)

ap config