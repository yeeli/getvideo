#coding:utf-8

module Getvideo
  class Tudou
    attr_accessor :url

    def initialize(uri)
      @url = uri
      @site = "http://v2.tudou.com/v"
      @info = parse_html(html_url)
      @body = Nokogiri::XML(response.body)
    end

    def id
      iid
    end

    def html_url
      if url =~ /\/(a|o|l)\/.*.\.swf/
       type = url.scan(/\/(a|o|l)\/.*.\.swf/)[0][0]
       case type
       when "a"
        "http://www.tudou.com/albumplay/#{acode}/#{lcode}.html"
       when "o"
         "http://www.tudou.com/oplay/#{acode}/#{lcode}.html"
       when "l"
         "http://www.tudou.com/listplay/#{acode}/#{lcode}.html"
       end
      elsif url =~ /\/(programs|albumplay|listplay|oplay)/
        url
      else
        "http://www.tudou.com/programs/view/#{lcode}/"
      end
    end

    def title
      @body.children()[0].attr("title")
    end

    def cover
      @info.body.match(/pic\s*:\s*(\S+)/)[1]
    end

    def flash
      if url =~ /\/(v|a|o|l)\/.*.\.swf/
        url
      elsif url =~ /\/(albumplay|listplay|oplay)/
        url_type = url.scan(/\/((a)lbumplay|(l)istplay|(o)play)/)[0][1]
        "http://www.tudou.com/#{url_type}/#{acode}/&rpid=116105338&resourceId=116105338_04_05_99&iid=#{iid}/v.swf"
      else
        "http://www.tudou.com/v/#{lcode}/&rpid=116105338&resourceId=116105338_04_05_99/v.swf"
      end
    end

    def m3u8
      "http://m3u8.tdimg.com/#{iid[0,3]}/#{iid[3,3]}/#{iid[6,3]}/2.m3u8"
    end

    def media
      video_list = {}
      video_list["f4v"] = []
      video_list["flv"] = []
      old_brt = ""
      @body.css("f").each do | file |
      brt = file.attr("brt")
      if brt != old_brt
        if file.content =~ /f4v/
          video_list["f4v"] << file.content
        elsif file.content =~ /flv/
          video_list["flv"] << file.content
        end
        old_brt = brt
      end
      end
      return video_list
    end

    def play_media
      media["f4v"]
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
      @site + "?it=" + iid 
    end

    def response
      uri = URI.parse info_path
      http = Net::HTTP.new uri.host, uri.port
      req = Net::HTTP::Get.new(uri.request_uri,{"User-Agent"=> ""})
      http.request req
    end

    def lcode
      if url =~ /\/v\/.*.\.swf/
        url.scan(/\/v\/([^\/]+)\//)[0][0]
      else
        Nokogiri::XML(response.body).children()[0].attr("code")
      end
    end

    def acode
      if url =~ /\/(a|o|l)\/.*.\.swf/
        url.scan(/\/[a|o|l]\/([^\/]+)\//)[0][0]
      elsif url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/
        url.scan(/\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/)[0][1]
      elsif url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\.html/
        url.scan(/\/(listplay|albumplay|oplay)\/([^.]+)\.html/)[0][1]
      end
    end

    def iid
      if url =~ /\/(programs|albumplay|listplay|oplay)/
        get_iid[0][0]
      elsif url =~ /\/v\/.*.\.swf/
        get_iid[0][0]
      elsif url =~ /\/(a|o|l)\/.*.\.swf/
        url.scan(/iid=([^\/]+)/)[0][0]
      else
        url
      end
    end

    def get_iid
      @info.body.scan(/iid\s*:\s*(\S+)/)
    end

    def parse_html(v_url)
      uri = URI.parse(v_url)
      http = Net::HTTP.new(uri.host, uri.port) 
      http.get(uri.path)
    end
  end
end
