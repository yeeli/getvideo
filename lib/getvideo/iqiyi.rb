#coding:utf-8

module Getvideo
  class Iqiyi
    attr_accessor :url

    def initialize(uri)
      @url = uri
      @site = "http://cache.video.qiyi.com/v/"
      @m_site = "http://cache.video.qiyi.com/m/"
      @body = Nokogiri::XML(response.body)
      @m_body = JSON.parse parse_m.scan(/ipadUrl=([^*]+)/)[0][0]
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
      @m_body["data"]["mtl"][1]["m3u"]
    end

    def flash
     position = @body.css("logoPosition").text
     duration = @body.css("totalDuration").text
     video_url =  @body.css("videoUrl").text.gsub("http://www.iqiyi.com/","")
     "http://player.video.qiyi.com/#{id}/#{position}/#{duration}/#{video_url}"[0..-5]+"swf"
    end

    def media
      video_list = {}
      video_list["mp4"] = []
      video_list["mp4"] << parse_mp4
      video_list["ts"] = []
      file =  @body.css("file")
      size = @body.css("size")
      #meta = []
      #meta_data = Nokogiri::XML Net::HTTP.get(URI.parse(@body.css("metaUrl").text))
      #meta_data.css("filepositions").each do |m|
      #  meta << m.children().last.text.gsub(/\d/,"9")
      #end
      file.zip(size).each do |f|
        video_list["ts"] << f[0].content[0..-4] + "ts?start=0&end=99999999&hsize=" + f[1].text
      end
      return  video_list
    end

    def play_media
      media["mp4"][0] if media["mp4"]
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

    def m_info_path
      info = @m_site + id + "/"
    end

    def parse_m
      uri = URI.parse m_info_path
      res = Net::HTTP.get uri
    end

    def parse_mp4(url=nil)
      site = @m_body["data"]["mp4Url"]
      uri = URI.parse site
      res = Net::HTTP.get uri
      res.scan(/"l":"([^,]+)"/)[0][0]
    end

    def parse_vid
      page_uri = URI.parse(url)
      page_doc = Net::HTTP.new(page_uri.host, page_uri.port)
      page_res = page_doc.get(page_uri.path)
      page_res.body.match(/\"videoId\"\s*[:=]\s*["']([^"']+)["']/)
    end
  end
end
