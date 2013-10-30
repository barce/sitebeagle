#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "net/https"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require 'optparse'


opts = OptionParser.new

OptionParser.new do |o|
  o.on('-h') { output_help; exit }
  o.parse!
end


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

# unfriend based on a list of screen names
fh = File.open("./unfollow_screen_name_list.txt")
fh.each do |line|
  s = line.chomp
  tmp = client.show(s)
  client.unfriend(tmp['id'])
  puts "#{s} is unfriended"
end
fh.close



