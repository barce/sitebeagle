#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require 'tweetstream'
require 'yajl'


yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

settings = YAML::load(yamlstring)
puts settings.inspect


if settings['access_token'].nil?

  puts "use get_oauth.rb to fill out info for access_token and access_secret."

end

TweetStream.configure do |config|
  config.consumer_key = settings['consumer_key']
  config.consumer_secret = settings['consumer_secret']
  config.oauth_token = settings['access_token']
  config.oauth_token_secret = settings['access_secret']
  config.auth_method = :oauth
  config.parser   = :yajl
end

track = ARGV[0].chomp

if track.nil?
  puts 'track is nil. usage: ./streaming_api.rb keyword_to_track'
  exit
end
TweetStream::Client.new.track(track) do |status|
  puts "#{status.inspect}"
end
