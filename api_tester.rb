#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require "./twitter_oauth_include.rb"




    # s_data = Net::HTTP.get_response(URI.parse(@url)).body
    # s_md5  = Digest::MD5.hexdigest(s_data)

client = my_client





puts "authorized? #{client.authorized?}"

# client.message("#{ARGV[2].chomp}", "something's changed with #{s.url} : alert #{i}")
puts client.followers()
