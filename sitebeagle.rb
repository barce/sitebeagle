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

def output_help

  puts "usage: sitebeagle.rb --url URL --user USER --alerts Number_of_alerts --regex REGEX"

end

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

    @s_md5

  end

  def pollurl

    self.first_md5   = getmd5
    self.current_md5 = getmd5

    while true
      sleep microwait
      self.current_md5 = getmd5
      return 0 if compare_hashes == false
    end

  end

  def compare_hashes 
    self.first_md5 == self.current_md5
  end
  
end


client = my_client

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
