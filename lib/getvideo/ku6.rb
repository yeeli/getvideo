#coding:utf-8

module Getvideo
  class Ku6
    def initialize(uri)
      @url = uri
      @site = "http://v.ku6.com/fetch.htm"
      @body = JSON.parse(response.body)
    end

    def url=(param)
      @url= param
    end

    def url
      @url
    end

    def id
      @url.split("/").last.split(".html")[0]
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

    def flv
      video_list = []
      @body["data"]["f"].split(",").each do |f|
        video_list << f
      end
      return video_list
    end

    private

    def response
      uri = URI.parse(@site)
      res = Net::HTTP.post_form(uri, {"t" => "getVideo4Player", "vid" => id})
      return res
    end
  end
end
