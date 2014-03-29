require 'net/http'
require 'uri'
require 'cgi'
require 'json'
require 'nokogiri'
require 'multi_json'
require 'multi_xml'
require 'getvideo/video'
require "getvideo/version"
require "getvideo/youku"
require "getvideo/ku6"
require "getvideo/56"
require "getvideo/tudou"
require "getvideo/sohu"
require "getvideo/iqiyi"
require "getvideo/youtube"
require 'getvideo/sina'

module Getvideo
  def self.parse(url)
    if url =~ /youku/
      Youku.new(url)
    elsif url =~ /tudou/
      Tudou.new(url)
    elsif url =~ /iqiyi/
      Iqiyi.new(url)
    elsif url =~ /sohu/
      Sohu.new(url)
    elsif url =~ /56\.com/
      Wole.new(url) 
    elsif url =~ /ku6/
      Ku6.new(url)
    elsif url =~ /youtube/
      Youtube.new(url)
    elsif url =~ /(iask|sina)/
      Sina.new(url)
    else
      return false
    end
  end
end
