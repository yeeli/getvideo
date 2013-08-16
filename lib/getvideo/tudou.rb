#coding:utf-8

module Getvideo
  class Tudou < Video
    attr_reader :info

    def initialize(url)
      @url = url
      parse_html
      tudou_connect
      @body = Nokogiri::XML(response)
    end

    def id
      iid
    end

    def html_url
      if url =~ /\/(a|o|l)\/.*.\.swf/
       type = url.scan(/\/(a|o|l)\/.*.\.swf/)[0][0]
       case type
       when "a"
        "http://www.tudou.com/albumplay/#{acode}#{"/" + lcode if lcode }.html"
       when "o"
         "http://www.tudou.com/oplay/#{acode}#{"/" + lcode if lcode}.html"
       when "l"
         "http://www.tudou.com/listplay/#{acode}#{"/" + lcode if lcode}.html"
       end
      elsif url =~ /dp\.tudou.com\/(a|o|l|v|albumplay|oplay|listplay)\//
        type = url.scan(/dp\.tudou.com\/(a|o|l|v|albumplay|oplay|listplay)\/.*.\.html/)[0][0]
        case type
       when "a", "albumplay"
        "http://www.tudou.com/albumplay/#{acode}#{"/" + lcode if lcode}.html"
       when "o", "oplay"
         "http://www.tudou.com/oplay/#{acode}#{"/" + lcode if lcode}.html"
       when "l", "listplay"
         "http://www.tudou.com/listplay/#{acode}#{"/" + lcode if lcode}.html"
       when "v"
         "http://www.tudou.com/programs/view/#{lcode}/"
       end
      elsif url =~ /www\.tudou.com\/(programs|albumplay|listplay|oplay)/
        url
      else
        "http://www.tudou.com/programs/view/#{lcode}/"
      end
    end

    def title
      @body.children()[0].attr("title")
    end

    def cover
      @info.match(/pic\s*:\s*(\S+)/)[1].delete("\"").gsub(/["|']/,"")
    end

    def flash
      if url =~ /\/(v|a|o|l)\/.*.\.swf/
        url
      elsif url =~ /\/(albumplay|listplay|oplay)/
        url_type = url.scan(/\/((a)lbumplay|(l)istplay|(o)play)/)[0].compact()[1]
        "http://www.tudou.com/#{url_type}/#{acode}/&rpid=116105338&resourceId=116105338_04_05_99&iid=#{iid}/v.swf"
      elsif url =~ /dp\.tudou\.com\/(l|a|o)/
        url_type = url.scan(/dp\.tudou.com\/(a|l|o)/)[0][0]
        "http://www.tudou.com/#{url_type}/#{acode}/&rpid=116105338&resourceId=116105338_04_05_99&iid=#{iid}/v.swf"
      elsif url =~ /dp\.tudou\.com\/v/
        "http://www.tudou.com/v/#{lcode}/&rpid=116105338&resourceId=116105338_04_05_99/v.swf"
      else
        "http://www.tudou.com/v/#{lcode}/&rpid=116105338&resourceId=116105338_04_05_99/v.swf"
      end
    end

    def m3u8
      "http://vr.tudou.com/v2proxy/v2.m3u8?it=#{iid}&st=2&pw="
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

    private

    def tudou_connect
      uri = URI.parse "http://v2.tudou.com/v?it=#{iid}"
      http = Net::HTTP.new uri.host, uri.port
      req = Net::HTTP::Get.new(uri.request_uri,{"User-Agent"=> ""})
      res = http.request req
      @response = res.body
    end

    def lcode
      if url =~ /\/v\/.*.\.swf/
        url.scan(/\/v\/([^\/]+)\//)[0][0]
      elsif url =~ /dp\.tudou\.com\/(l|a|o|listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/
        url.scan(/dp\.tudou\.com\/(?:l|a|o|listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/)[0][1]
      elsif url =~ /dp\.tudou\.com\/(l|a|o|listplay|albumplay|oplay)\/([^.]+)\.html/
        nil
      elsif url =~ /dp\.tudou\.com\/v\/([^.]+)\.html/
        url.scan(/dp\.tudou\.com\/v\/([^.]+)\.html/)[0][0]
      else
        tudou_connect
        Nokogiri::XML(response).children()[0].attr("code")
      end
    end

    def acode
      if url =~ /\/(a|o|l)\/.*.\.swf/
        url.scan(/\/[a|o|l]\/([^\/]+)\//)[0][0]
      elsif url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/
        url.scan(/\/(?:listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/)[0][0]
      elsif url =~ /dp\.tudou\.com\/(l|a|o)\/([^.]+)\/([^.]+)\.html/
        url.scan(/dp\.tudou\.com\/(?:l|a|o)\/([^.]+)\/([^.]+)\.html/)[0][0]
      elsif url =~ /dp\.tudou\.com\/(l|a|o)\/([^.]+)\.html/
        url.scan(/dp\.tudou\.com\/(?:l|a|o)\/([^.]+)\.html/)[0][0]

      elsif url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\.html/
        url.scan(/\/(?:listplay|albumplay|oplay)\/([^.]+)\.html/)[0][0]
      end
    end

    def iid
      if url =~ /\/(programs|albumplay|listplay|oplay)/
        get_iid[0][0]
      elsif url =~ /\/v\/.*.\.swf/
        get_iid[0][0]
      elsif url =~ /\/(a|o|l)\/.*.\.swf/
        url.scan(/iid=([^\/]+)/)[0][0]
      elsif url =~ /dp\.tudou\.com\/(a|o|l|v)\//
        get_iid[0][0]
      elsif url =~ /dp\.tudou\.com\/player\.php/
        url.scan(/player\.php\?id=([^&]+)/)[0][0]
      elsif url =~ /dp.tudou.com\/nplayer\.swf/
        url.scan(/nplayer\.swf\?([^&]+)/)[0][0]
      else
        url
      end
    end

    def get_iid
      @info.scan(/iid\s*:\s*(\S+)/)
    end

    def parse_html
      conn = Faraday.new
      res = conn.get html_url
      @info = res.body
    end
  end
end
