#coding:utf-8

module Getvideo
  class Ku6
    attr_accessor :url
    def initialize(uri)
      @url = uri
      @site = "http://v.ku6.com/fetch.htm"
      @body = JSON.parse(response.body)
    end

    def html_url
      if url =~ /\.html/
        url
      else
        "http://v.ku6.com/show/#{id}.html"
      end
    end

    def title
      @body["data"]["t"]
    end

    def id
      if url =~ /\.html/
        url.split("/").last.split(".html")[0]
      elsif url =~ /\.swf/
        url.split("/")[-2]
      else
        url
      end
    end

    def cover
      @body["data"]["bigpicpath"]
    end

    def flash
      "http://player.ku6.com/refer/#{id}/v.swf"
    end

    def m3u8
      "http://v.ku6.com/fetchwebm/#{id}.m3u8"
    end

    def media
      video_list = {}
      video_list["f4v"] = []
      @body["data"]["f"].split(",").each do |f|
        video_list["f4v"] << f
      end
      return video_list
    end

    def play_media
      media["f4v"][0]
    end

    def json
      {id: id,
       url: html_url,
       cover: cover,
       title: title,
       m3u8: m3u8,
       flash: flash,
       media: play_media}.to_json
    end

    private

    def response
      uri = URI.parse(@site)
      res = Net::HTTP.post_form(uri, {"t" => "getVideo4Player", "vid" => id})
      return res
    end
  end
end
