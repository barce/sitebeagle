#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'



    # s_data = Net::HTTP.get_response(URI.parse(@url)).body
    # s_md5  = Digest::MD5.hexdigest(s_data)

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

# client.message("#{ARGV[2].chomp}", "something's changed with #{s.url} : alert #{i}")
puts client.followers()
