#!/usr/bin/env ruby
require "rubygems"
# require "mysql"
require "date"
require "yaml"
require "net/http"
require "uri"
require "oauth2"

yamlstring = ''
File.open("./viame.yaml", "r") { |f|
  yamlstring = f.read
}

settings = YAML::load(yamlstring)
puts settings.inspect

CLIENT_ID     = settings['consumer_key']
CLIENT_SECRET = settings['consumer_secret']
CALLBACK_URL  = 'http://127.0.0.1:4001/photos/callback'
PROVIDER_URL  = 'http://localhost.com:3000/'

client = OAuth2::Client.new(
  CLIENT_ID,
  CLIENT_SECRET, 
  :authorize_url => "/oauth/authorize", 
  :token_url => "/oauth/access_token", 
  :site => PROVIDER_URL,
)

puts client.auth_code.authorize_url(:redirect_uri => CALLBACK_URL)
puts "gets.chomp"
code = gets.chomp
# code = "apdae76nbe7gs47r2ai5kqv1z"

token = client.auth_code.get_token(code, :redirect_uri => CALLBACK_URL, :response_type => 'token')

token = OAuth2::AccessToken.new(client, token.token, {
  :mode => :query,
  :param_name => "oauth_token",
})

# response = token.get('https://api.foursquare.com/v2/users/self/checkins')
response = token.get('http://localhost:3000/api/v1/users/b2test.json')

puts response.body
