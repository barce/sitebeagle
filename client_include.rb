def setup_client(settings)
  client = TwitterOAuth::Client.new(
        :consumer_key => settings['consumer_key'],
        :consumer_secret => settings['consumer_secret'],
        :token => settings['access_token'],
        :secret => settings['access_secret']
  )
  client
end
