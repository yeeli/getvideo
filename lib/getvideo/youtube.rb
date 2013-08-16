#coding:utf-8

module Getvideo
  class Youtube < Video

    def html_url
      if url =~ /(?:v=|youtu\.be\/)/
        url
      else
        "http://www.youtube.com/watch?v=" + id
      end
    end

    def id
      if url =~ /(?:v=|youtu\.be\/|youtube\.com\/v\/)([^.|&]+)/
        url.scan(/(?:v=|youtu\.be\/|youtube\.com\/v\/)([^.|&]+)/)[0][0]
      else
        url
      end
    end

    def cover
      CGI::unescape(response.scan(/thumbnail_url=([^&]+)/)[0][0]).gsub("default.jpg","")+"0.jpg"
    end

    def flash
      "http://www.youtube.com/v/#{id}"
    end

    def m3u8
      media["mp4"][0]
    end

    def media
      stream = CGI::unescape(response.scan(/url_encoded_fmt_stream_map=([^&]+)/)[0][0])
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

    def title
      CGI::unescape response.scan(/title=([^&]+)/)[0][0]
    end

    private

    def connection
      conn = Faraday.new
      res = conn.post "http://www.youtube.com/get_video_info", { "video_id" => id }
      @response = Response.new(res).body
    end
  end
end
