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

client = OAuth2::Client.new(
  CLIENT_ID,
  CLIENT_SECRET, 
  :authorize_url => "/oauth/authorize", 
  :token_url => "/oauth/access_token", 
  :site => "http://localhost.com:3000/",
)

puts client.auth_code.authorize_url(:redirect_uri => "http://hipsterhookups.com/photos/callback")
puts "gets.chomp"
code = gets.chomp

token = client.auth_code.get_token(code, :redirect_uri => "http://hipsterhookups.com/photos/callback")

token = OAuth2::AccessToken.new(client, token.token, {
  :mode => :query,
  :param_name => "oauth_token",
})

# response = token.get('https://api.foursquare.com/v2/users/self/checkins')
response = token.get('http://localhost:3000/api/v1/users/b2test.json')

puts response.body
