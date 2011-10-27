#!/usr/bin/env ruby


require "rubygems"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'

class Sitebeagle

  attr_accessor :url, :first_md5, :current_md5, :microwait, :myregex

  #
  # furl: create a diskspace friendly url
  #
  def furl

  end

  def getmd5

    # add begin rescue ensure here
    begin

      s_data = Net::HTTP.get_response(URI.parse(self.url)).body
      unless self.myregex.nil?
	if s_data =~ /(#{self.myregex})/
	  s_md5  = Digest::MD5.hexdigest(self.myregex)
	  puts "using regex"
	  puts "md5: #{s_md5}"
	else 
	  s_md5  = Digest::MD5.hexdigest(s_data)
	  puts "not using regex"
	  puts "md5: #{s_md5}"
	end

      end
      stuff = File.open("#{s_md5}.txt", "w")
      stuff.write(self.url)
      stuff.write("\n")
      stuff.write("\n")
      stuff.write(s_data)
      stuff.close

    rescue Net::Error => e
      puts "Error code: #{e.errno}"
      puts "Error message: #{e.error}"
    ensure
      if s_data.nil?
	return Digest::MD5.hexdigest("")
      else
	return Digest::MD5.hexdigest(s_data)
      end
    end

    return s_md5

  end

  def pollurl

    self.first_md5    = self.getmd5
    self.current_md5 = self.getmd5

    i_sent = 1
    while i_sent == 1

      sleep self.microwait
      self.current_md5 = getmd5
      if self.first_md5 != self.current_md5
        i_sent = 0
      end
      t = Time.new
      puts t
      puts self.url
      puts "first_md5:   #{self.first_md5}"
      puts "current_md5: #{self.current_md5}"
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
# send DMs to this account
# regex
puts ARGV.inspect
puts ARGV[0]
puts ARGV[1]
puts ARGV[2]
puts ARGV[3]

s = Sitebeagle.new
s.url = ARGV[0].chomp
puts s.url
unless ARGV[3].nil?
  s.myregex = ARGV[3].chomp
end
s.microwait = ARGV[1].chomp.to_i
puts "s.getmd5 #{s.getmd5}"
s.pollurl

i = 1
5.times do
  client.message("#{ARGV[2].chomp}", "something's changed with #{s.url} : alert #{i}")
  sleep 5
  i = i + 1
end
