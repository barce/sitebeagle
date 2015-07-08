#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require 'optparse'


opts = OptionParser.new

OptionParser.new do |o|
  o.on('-h') { output_help; exit }
  o.on('--user USER') { |user| $user = user }
  o.on('--message MESSAGE') { |message| $message = message }
  o.parse!
end

user    = $user
message = $message

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






puts "authorized? #{client.authorized?}"

# url
# alerts
# send DMs to this account
# regex

# client.message("#{user.chomp}", "#{message}")

@woeid = nil
@places = client.available_trends
@places.each do |place|
  if place['name'] == 'United States'
    @woeid = place['woeid']
  end
end

puts client.place_trends 1
