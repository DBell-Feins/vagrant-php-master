require 'yaml'
require 'json'

CONFIG_PATH = File.join(Dir.pwd, "config")
begin
  base_config = YAML.load_file(File.join(CONFIG_PATH, 'default.yml'))
rescue Errno::ENOENT
  puts "FAILED"
end
#puts base_config

config = ''
Dir.foreach(CONFIG_PATH) do |item|
    next if item == '.' or item == '..' or item == 'default.yml'
      #puts item
      if File.extname(item) == '.yml' then
        local = JSON.parse(YAML.load_file(File.join(CONFIG_PATH, item)).to_json)

        puts local.class()
      end
  end

#puts config