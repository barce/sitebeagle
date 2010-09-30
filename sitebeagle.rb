#!/usr/bin/env ruby


require "rubygems"
require "mysql"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'

puts "Hi"

class Sitebeagle

  attr_accessor :url, :first_md5, :current_md5, :microwait, :myregex

  #
  # furl: create a diskspace friendly url
  #
  def furl

  end

  def getmd5

    s_data = Net::HTTP.get_response(URI.parse(@url)).body
    s_md5  = Digest::MD5.hexdigest(s_data)

    return s_md5

  end

  def pollurl

    @first_md5    = getmd5
    @currenct_md5 = getmd5

    i_sent = 1
    while i_sent == 1

      sleep @microwait
      @current_md5 = getmd5
      if @first_md5 != @current_md5
        i_sent = 0
      end
      t = Time.new
      puts t
      puts @first_md5
      puts @current_md5
      puts i_sent

    end

  end
  
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

# url
# alerts
# regex
puts ARGV.inspect
puts ARGV[0]
puts ARGV[1]
puts ARGV[2]

s = Sitebeagle.new
s.url = ARGV[0]
puts s.url
s.microwait = ARGV[1].to_i
puts s.getmd5
s.pollurl

5.times do
  client.message("barce", "something's changed with #{s.url}")
  sleep 5
end
