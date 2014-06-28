#coding:utf-8

module Getvideo
  class Sina < Video
    set_api_uri { "http://v.iask.com/v_play.php?vid=#{id}" }

    def initialize(url)
      @url = url
      set_id
    end

    def ipad_response
      @ipad_response ||= ipad_connect
    end

    def info_response
      @info_response ||= Nokogiri::HTML(parse_html).css("head script").text.gsub(" ", "")
    end

    def html_url
      if has_html?
        if url =~ /\.html$/
          url
        else
          "http://video.sina.com.cn/v/b/#{@id}-#{@uid}.html"
        end
      else
        ""
      end
    end

    def title
      if has_html?
        info_response.scan(/title:'([^']+)'/)[0][0]
      else
        response["vname"]
      end
    end

    def cover
      if has_html?
        pic = info_response.scan(/pic:'([^']+)'/)
        pic.empty? ? "" : pic[0][0]
      else
        ""
      end
    end

    def flash
      if url =~ /\.swf/
        url
      else
        flash_url = info_response.scan(/swfOutsideUrl:'([^']+)'/)
        unless flash_url.empty?
          flash_url[0][0]
        else
          ""
        end
      end
    end

    def m3u8
      if has_html?
        if !ipad_response.nil? 
          media["mp4"][0]
        end
      else
        ""
      end
    end

    def id
      @id
    end

    def media
      vedio_list = {}
      vedio_list["hlv"] = []
      vedio_list["mp4"] = []
      if res = response
        if res["video"]["result"] != "error"
          vedio_list["hlv"] << res["video"]["durl"]["url"]
        end
      end

      if m_res = ipad_response
        if m_res["video"]["result"] != "error"
          vedio_list["mp4"] << m_res["vdieo"]["durl"]["url"]
        end
      end

      return vedio_list
    end

    private

    def has_html?
      @uid =~ /[\d]{3,}?/ || (url =~ /\.html/)
    end

    def set_id
      if url =~ /\/v\/b\/([^\D]+)-([^\D]+)\.html/
        if ids =  url.scan(/\/v\/b\/([^\D]+)-([^\D]+)\.html/)[0]
          @id = ids[0]
          @uid = ids[1]
        end
      elsif url =~ /\/playlist\/([^\D]+).*.#([^\D]+)/
        if ids = url.scan(/\/playlist\/[^\D]+-([^\D]+).*#([^\D]+)/)[0]
          @id = ids[1]
          @uid = ids[0]
        end
      elsif url =~ /\.swf/
        if ids = url.scan(/vid=([^\D]+)_([^\D]+)_.+\.swf/)[0]
          @id = ids[0]
          @uid = ids[1]
        end
      elsif url =~ /(\/[\S]?\/)/
        if url.index("#").nil?
          html = parse_html
          if uids = html.scan(/uid[\s]?:[\s]?['|"]([^\D]+)['|"]/)[0]
            @uid = uids[0]
          end
          if ids = html.scan(/vid[\s]?:[\s]?['|"]([^\D]+)['|"]/)[0]
            @id = ids[0]
          end
        else
          if ids = url.scan(/(\/[\S]?\/).+#([^\D]+)/)[0]
            @id = ids[1]
          end
        end
      else
        if ids = url.split("|")
          @id = ids[0]
          @uid = ids[1]
        end
      end
    end

    def ipad_id
      ipad_ids = info_response.scan(/videoData:{ipad_vid:[']?([^\D]+)[']?/)
      ipad_ids.empty? ? nil : ipad_ids[0][0]
    end

    def ipad_connect
      conn = Faraday.new
      response = conn.get "http://v.iask.com/v_play.php?vid=#{ipad_id}"
      Response.new(response).parsed
    end

    def html_info_path
      if url =~ /\.html/
        if url.index("#")
          if url =~ /play_list/
            html_url
          else
            url
          end
        else
          url
        end
      elsif url =~ /\.swf/
        html_url
      else
        html_url
      end
    end

    def parse_html
      if !html_info_path.empty?
        conn = Faraday.new
        conn.get(html_info_path).body
      end
    end

    def get_media(type=nil)
      if type == "mp4"
        if ipad_id
          uri = "http://v.iask.com/v_play.php?vid=#{ipad_id}"
        end
      else
        uri = "http://v.iask.com/v_play.php?vid=#{id}"
      end
      conn = Faraday.new
      return conn.get(uri).body
    end
  end
end
