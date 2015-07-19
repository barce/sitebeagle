require "./client_include.rb"

def my_client
  yamlstring = ''
  File.open("./auth.yaml", "r") { |f|
    yamlstring = f.read
  }
  
  settings = YAML::load(yamlstring)
  puts settings.inspect
  
  
  if settings['access_token'].nil?
  
    puts "use get_oauth.rb to fill out info for access_token and access_secret."
    exit
  end
  
  client = setup_client settings
end
