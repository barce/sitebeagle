#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require 'optparse'
require "./twitter_oauth_include.rb"


opts = OptionParser.new

OptionParser.new do |o|
  o.on('-h') { output_help; exit }
  o.on('--user USER') { |user| $user = user }
  o.on('--message MESSAGE') { |message| $message = message }
  o.parse!
end

def output_help
  puts "usage: dm.rb --user USER --message MESSAGE"
end

user    = $user
message = $message


client = my_client



puts "authorized? #{client.authorized?}"

# url
# alerts
# send DMs to this account
# regex

client.message("#{user.chomp}", "#{message}")
