def my_client
  yamlstring = ''
  File.open("./auth.yaml", "r") { |f|
    yamlstring = f.read
  }
  
  settings = YAML::load(yamlstring)
  puts settings.inspect
  
  
  if settings['access_token'].nil?
  
    puts "use get_oauth.rb to fill out info for access_token and access_secret."
  
  end
  
  client = TwitterOAuth::Client.new(
          :consumer_key => settings['consumer_key'],
          :consumer_secret => settings['consumer_secret'],
          :token => settings['access_token'],
          :secret => settings['access_secret']
  )
  client
end
