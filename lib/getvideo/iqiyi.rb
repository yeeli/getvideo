#coding:utf-8

module Getvideo
  class Iqiyi
    attr_accessor :url

    def initialize(uri)
      @url = uri
      @site = "http://cache.video.qiyi.com/v/"
      @body = Nokogiri::XML(response.body)
    end

    def html_url
      @body.css("videoUrl").text
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
      @body.css("title").text
    end

    def cover
      @body.css("albumImage").text
    end

    def m3u8
      @body.css("metaUrl").text[0..-4] + "m3u8"
    end

    def flash
     position = @body.css("logoPosition").text
     duration = @body.css("totalDuration").text
     video_url =  @body.css("videoUrl").text.gsub("http://www.iqiyi.com/","")
     "http://player.video.qiyi.com/#{id}/#{position}/#{duration}/#{video_url}"[0..-5]+"swf"
    end

    def media
      video_list = {}
      video_list["ts"] = []
      @body.css("file").each do |f|
        video_list["ts"] << f.content[0..-4] + "ts"
      end
      return  video_list
    end

    def play_media
      media["ts"]
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

    def info_path
      @site + id
    end

    def response
      uri = URI.parse(info_path) 
      http= Net::HTTP.new(uri.host, uri.port)
      res = http.get(uri.path)
    end

    def parse_vid
      page_uri = URI.parse(url)
      page_doc = Net::HTTP.new(page_uri.host, page_uri.port)
      page_res = page_doc.get(page_uri.path)
      page_res.body.match(/\"videoId\"\s*[:=]\s*["']([^"']+)["']/)
    end
  end
end
