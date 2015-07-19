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
require "./twitter_oauth_include.rb"



opts = OptionParser.new

OptionParser.new do |o|
  o.on('-h') { output_help; exit }
  o.parse!
end


client = my_client




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



