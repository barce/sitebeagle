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
  o.on('--url URL') { |url| $url = url }
  o.on('-h') { output_help; exit }
  o.on('--user USER') { |user| $user = user }
  o.on('--alerts ALERTS') { |alerts| $alerts = alerts }
  o.on('--regex REGEX') { |regex| $regex = regex }
  o.parse!
end

url    = $url
user   = $user
alerts = $alerts
regex  = $regex

class Sitebeagle

  attr_accessor :url, :first_md5, :current_md5, :microwait, :myregex

  #
  # furl: create a diskspace friendly url
  #
  def furl

  end

  def getmd5

    @s_md5 = ''
    @s_data = ''
    # add begin rescue ensure here
    begin

      puts "calling url: #{self.url}"
      @s_data = Net::HTTP.get_response(URI.parse(self.url)).body
      # http = Net::HTTP.new('api.via.me', 80)
      #http.open_timeout = 5
      #http.read_timeout = 5
      #request = Net::HTTP::Get.new(URI.parse(self.url))

      # puts "-- s_data --"
      # puts s_data
      begin
        if self.myregex.length > 0
          if @s_data =~ /(#{self.myregex})/
            @s_data = $1
          end
        end
      rescue
        # silent
      end
      @s_md5  = Digest::MD5.hexdigest(@s_data)
      puts "myregex: (#{self.myregex})"

      puts "md5: #{@s_md5}"

      puts "writing file #{@s_md5}.txt ..."
      stuff = File.open("#{@s_md5}.txt", "w")
      stuff.write(self.url)
      stuff.write("\n")
      stuff.write("\n")
      stuff.write(@s_data)
      stuff.close

    rescue Net::HTTPError => e
      puts "Error code: #{e.errno}"
      puts "Error message: #{e.error}"
    ensure
      if @s_data.nil?
	return Digest::MD5.hexdigest("")
      else
	return Digest::MD5.hexdigest(@s_data)
      end
    end

    return @s_md5

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

s = Sitebeagle.new
s.url = url
puts s.url
s.myregex = regex
s.microwait = 60
puts "s.getmd5 #{s.getmd5}"
s.pollurl

i = 1
alerts.to_i.times do
  client.message("#{user.chomp}", "something's changed with #{s.url} : alert #{i}")
  sleep 5
  i = i + 1
end
