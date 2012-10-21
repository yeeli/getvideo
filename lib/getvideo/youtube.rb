#coding:utf-8

module Getvideo
  class Youtube
    attr_accessor :url
    def initialize(uri)
      @url = uri
      @site = "http://www.youtube.com/get_video_info"
      @body =response.body
    end

    def html_url
      if url =~ /(?:v=|youtu\.be\/)/
        url
      else
        "http://www.youtube.com/watch?v=" + id
      end
    end

    def id
      #url.split("?")[1].split("&")[0].split("=")[1]
      if url =~ /(?:v=|youtu\.be\/|youtube\.com\/v\/)([^.|&]+)/
        url.scan(/(?:v=|youtu\.be\/|youtube\.com\/v\/)([^.|&]+)/)[0][0]
      else
        url
      end
    end

    def cover
      CGI::unescape(@body.scan(/thumbnail_url=([^&]+)/)[0][0]).gsub("default.jpg","")+"0.jpg"
    end

    def flash
      "http://www.youtube.com/v/#{id}"
    end

    def m3u8
      media["mp4"][0]
    end

    def media
      stream = CGI::unescape(@body.scan(/url_encoded_fmt_stream_map=([^&]+)/)[0][0])
      media = stream.scan(/url=([^&]+)/)
      sig = stream.scan(/sig=([^&]+)/)
      type = stream.scan(/type=([^&]+)/)
      vedio_list = {}
      media.zip(sig, type).each do |m|
        m_type = m[2][0].match(/(flv|mp4|webm|3gp)/)[0] 
        u = CGI::unescape(m[0][0])+ "&signature=" + m[1][0]
        if vedio_list[m_type].nil?
          vedio_list[m_type] = []
          vedio_list[m_type] << u
        else
          vedio_list[m_type] << u
        end
      end
      return vedio_list
    end

    def play_media
      media["flv"]
    end

    def title
      CGI::unescape @body.scan(/title=([^&]+)/)[0][0]
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
      @site 
    end

    def response
      uri = URI.parse(info_path)
      res = Net::HTTP.post_form(uri, { "video_id" => id })
    end
  end
end
