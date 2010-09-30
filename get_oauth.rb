#!/usr/bin/env ruby


require "rubygems"
require "mysql"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"

puts "Hi"

yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

settings = YAML::load(yamlstring)
puts settings.inspect

# request token url:
# https://api.twitter.com/oauth/request_token
# 
# access token url:
# https://api.twitter.com/oauth/access_token
# 
# authorize url:
# https://api.twitter.com/oauth/authorize
#
# my oauth callback url
# http://l33tcave.com/home/
oauth_confirm_url = 'http://l33tcave.com/home/'


if settings['access_token'].nil?

	client = TwitterOAuth::Client.new(
	    :consumer_key => settings['consumer_key'],
	    :consumer_secret => settings['consumer_secret']
	)
	# request_token = client.request_token(:oauth_callback => oauth_confirm_url)
	request_token = client.request_token()
	# request_token.inspect
	puts "Go to this URL: "
	puts "#{request_token.authorize_url}"
	print "Enter the verifier here: "
	verifier = gets
	verifier = verifier.chomp
	
	
	
	access_token = client.authorize(
	  request_token.token,
	  request_token.secret,
	  :oauth_verifier => verifier
	)
	
	puts "request_token: #{request_token.token}"
	puts "request_secret: #{request_token.secret}"
	puts "access_token: #{access_token.token}"
	puts "access_secret: #{access_token.secret}"

else


	client = TwitterOAuth::Client.new(
	    :consumer_key => settings['consumer_key'],
	    :consumer_secret => settings['consumer_secret'],
	    :token => settings['access_token'],
	    :secret => settings['access_secret']
	)



end



puts "authorized? #{client.authorized?}"

