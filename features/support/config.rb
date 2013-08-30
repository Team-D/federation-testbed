require 'yaml'

def read_config
  config = YAML::load(File.open('features/support/config.yml'))
  @diaspora_user = config['diaspora_user']
  @server = config['server']
  @guid = config["guid"]
  @private_key = config["private_key"]
end

