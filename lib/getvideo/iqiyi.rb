#coding:utf-8

module Getvideo
  class Iqiyi < Video
    set_api_uri { "http://cache.video.qiyi.com/v/#{id}" }
    attr_reader :ipad_response

    def initialize(url)
      super
      ipad_connection
    end

    def html_url
      response.css("videoUrl").text
    end

    def id
     if url =~ /\.html/
       parse_vid[1]
     elsif url =~ /swf/
       url.scan(/com\/([^\/]+)/)[0][0]
     else
        url
     end
    end

    def title
      response.css("title").text
    end

    def cover
      response.css("albumImage").text
    end

    def m3u8
      ipad_response["data"]["mtl"][1]["m3u"]
    end

    def flash
     position = response.css("logoPosition").text
     duration = response.css("totalDuration").text
     video_url =  response.css("videoUrl").text.gsub("http://www.iqiyi.com/","")
     "http://player.video.qiyi.com/#{id}/#{position}/#{duration}/#{video_url}"[0..-5]+"swf"
    end

    def media
      video_list = {}
      video_list["mp4"] = []
      video_list["mp4"] << parse_mp4
      video_list["ts"] = []
      file =  response.css("file")
      size = response.css("size")
      file.zip(size).each do |f|
        video_list["ts"] << f[0].content[0..-4] + "ts?start=0&end=99999999&hsize=" + f[1].text
      end
      return  video_list
    end

    private

    def ipad_connection
      conn = Faraday.new
      response= conn.get "http://cache.video.qiyi.com/m/#{id}/"
      @ipad_response = MultiJson.load response.body.scan(/ipadUrl=([^*]+)/)[0][0]
    end

    def parse_mp4(url=nil)
      site = ipad_response["data"]["mp4Url"]
      conn = Faraday.new
      res = conn.get(site)
      res.body.scan(/"l":"([^,]+)"/)[0][0]
    end

    def parse_vid
      conn = Faraday.new
      page_res = conn.get(url)
      return page_res.body.match(/data-player-videoid\s*[:=]\s*["']([^"']+)["']/)
    end
  end
end
