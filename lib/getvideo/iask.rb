#coding:utf-8

module Getvideo
  class Iask
    attr_accessor :url
    def initialize(uri)
      @url = uri
      @site = "http://v.iask.com/v_play.php"
      get_id()
      @body = Nokogiri::XML(response)
      if has_html?
        @info = Nokogiri::HTML(parse_html).css("head script").text.gsub(" ", "")
        @ipad_body = Nokogiri::XML(response("ipad")) if ipad_id
      end
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
        @info.scan(/title:'([^']+)'/)[0][0]
      else
        @body.css("vname").text
      end
    end

    def cover
      if has_html?
        pic = @info.scan(/pic:'([^']+)'/)
        pic.empty? ? "" : pic[0][0]
      else
        ""
      end
    end

    def flash
      if url =~ /\.swf/
        url
      else
        flash_url = @info.scan(/swfOutsideUrl:'([^']+)'/)
        unless flash_url.empty?
          flash_url[0][0]
        else
          ""
        end
      end
    end

    def m3u8
      if has_html?
        @ipad_body.nil? ? "" : media["mp4"][0] 
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

      @body.css("url").each do |d|
        vedio_list["hlv"] << d.text
      end

      if @ipad_body
        vedio_list["mp4"] = []
        @ipad_body.css("url").each do |d|
          vedio_list["mp4"] << d.text
        end
      end

      return vedio_list
    end

    def play_media
      media["hlv"]
    end

    def json
      vid = @id + "|" + @uid
      {id: vid,
       url: html_url,
       cover: cover,
       title: title,
       m3u8: m3u8,
       flash: flash,
       media: play_media}.to_json
    end

    private

    def has_html?
      @uid =~ /[\d]{3,}?/ || (url =~ /\.html/)
    end

    def get_id
      if url =~ /\/v\/b\/([^\D]+)-([^\D]+)\.html/
        ids =  url.scan(/\/v\/b\/([^\D]+)-([^\D]+)\.html/)[0]
        @id = ids[0]
        @uid = ids[1] 
      elsif url =~ /\/playlist\/([^\D]+).*.#([^\D]+)/
        ids = url.scan(/\/playlist\/[^\D]+-([^\D]+).*#([^\D]+)/)[0]
        @id = ids[1]
        @uid = ids[0] 
      elsif url =~ /\.swf/
        ids = url.scan(/vid=([^\D]+)_([^\D]+)_.+\.swf/)[0]
        @id = ids[0]
        @uid = ids[1] 
      elsif url =~ /(\/[\S]?\/)/ 
        if url.index("#").nil?
          html = parse_html
          ids = html.scan(/vid[\s]?:[\s]?['|"]([^\D]+)['|"]/)[0]
          uids = html.scan(/uid[\s]?:[\s]?['|"]([^\D]+)['|"]/)[0]
          @id = ids[0]
          @uid = uids[0]
        else
          ids = url.scan(/(\/[\S]?\/).+#([^\D]+)/)[0]
            @id = ids[1]
        end
      else
        ids = url.split("|")
        @id = ids[0]
        @uid = ids[1]
      end
    end

    def ipad_id
      ipad_ids = @info.scan(/videoData:{ipad_vid:[']?([^\D]+)[']?/)
      ipad_ids.empty? ? nil : ipad_ids[0][0]
    end

    def info_path(l_id = nil)
      vid = l_id.nil? ? id : l_id
      @site + "?vid=" + vid 
    end

    def response(type = nil)
      vid = ipad_id if type == "ipad"
      uri = URI.parse(info_path(vid))
      res = Net::HTTP.get(uri)
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


    def parse_html()
      uri = URI.parse(html_info_path)
      body = Net::HTTP.get(uri)
    end


    def get_media(type=nil)
      if type == "mp4"
        if ipad_id
          uri = URI.parse("#{@site}?vid=#{ipad_id}")
        end
      else
        uri = URI.parse("#{@site}?vid=#{id}")
      end
      res = Net::HTTP.get(uri)
      return res
    end
  end
end
