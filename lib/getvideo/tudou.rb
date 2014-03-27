#coding:utf-8

module Getvideo
  class Tudou < Video

    set_api_uri do
      if url_type == "albumplay" || url_type == "oplay"
        "http://v.youku.com/player/getPlayList/VideoIDS/#{page_get_vcode}"
      else
        "http://www.tudou.com/outplay/goto/getItemSegs.action?iid=#{page_get_iid}"
      end
    end

    def initialize(url)
      @url = url
      parse_page
      get_type
      if !swf_iid && url_type != "views"
        get_item_info(page_get_iid)
      end
    end

    def id
      page_get_iid
    end

    def html_url
      case url_type
      when "views"
        "http://www.tudou.com/programs/view/#{page_get_icode}/"
      when "albumplay", "oplay"
        "http://www.tudou.com/albumplay/#{page_get_lcode}/#{page_get_icode}.html"
      when "listplay"
        "http://www.tudou.com/listplay/#{page_get_lcode}/#{page_get_icode}.html"
      end
    end

    def title
      if page_get_title.encoding != 'UTF-8'
        CGI.unescapeHTML(page_get_title)
      else
        page_get_title
      end
    end

    def cover
      if url_type == "albumplay" || url_type == "oplay"
        response["data"][0]["logo"]
      else
        page_get_pic
      end
    end

    def flash
      case url_type
      when "views"
        "http://www.tudou.com/v/#{page_get_icode}/v.swf"
      when "albumplay", "oplay"
        "http://www.tudou.com/a/#{page_get_lcode}/&iid=#{page_get_iid}/v.swf"
      when "listplay"
        "http://www.tudou.com/l/#{page_get_lcode}/&iid=#{page_get_iid}/v.swf"
      end
    end

    def m3u8
      "http://vr.tudou.com/v2proxy/v2.m3u8?it=#{page_get_iid}&st=2&pw="
    end

    def media(type = nil)
      if url_type == "albumplay" || url_type == "oplay"
        albumplay_media(type)
      else
        view_media(type)
      end
    end

    private

    def get_items
      if url_type == "albumplay" || url_type == "oplay"
        Getvideo::Response.new(Faraday.get("http://www.tudou.com/outplay/goto/getAlbumItems.html?aid=#{page_get_lid}")).parsed
      elsif url_type == "listplay"
        Getvideo::Response.new(Faraday.get("http://www.tudou.com/outplay/goto/getPlaylistItems.html?lid=#{page_get_lid}")).parsed
      else
        nil
      end
    end

    def get_item_info(id)
      get_items["message"].each do |item|
        if item["itemId"].to_s == id
          @item_info = item
          break
        end
      end
    end

    def parse_page
      video_url = get_url
      if swf_iid
        res = Faraday.get(video_url)
        @swf_info = {}
        res.headers['location'].split("?")[1].split("&").each do |data|
          data_info =  data.split("=")
          if data_info.length > 1
            @swf_info[data_info[0]] = CGI::unescape(data_info[1])
          end
        end
      else
        @page = Getvideo::Response.new(Faraday.get(video_url)).parsed.css("script").text
      end
    end

    def get_type
      type = url.match(/\/(v|a|o|l|listplay|albumplay|oplay|programs)\//)[1]
      @url_type = case type
                  when "v", "programs"
                    "views"
                  when "a", "albumplay"
                    "albumplay"
                  when "o",  "oplay"
                    "oplay"
                  when "l", "listplay"
                    "listplay"
                  end
    end

    def get_url
      if url =~ /\/(a|o|l)\/.*.\.swf/
        code = url.match(/\/[a|o|l]\/([^\/]+)\//)[1]
        @swf_iid = url.match(/iid=([^&]+)/)[1]
        type = url.match(/\/(a|o|l)\/.*.\.swf/)[1]
        url
      elsif url =~ /\/v\/.*.\.swf/
        code = url.match(/\/v\/([^\/]+)\//)[1]
        "http://www.tudou.com/programs/view/#{code}/"
      elsif url =~ /www\.tudou.com\/oplay/
        url_id = url.match(/www\.tudou.com\/oplay\/(.*.).html/)[1]
        "http://www.tudou.com/albumplay/#{url_id}.html"
      else
        url
      end
    end

    def page_get_lid
      if swf_iid
        if url_type == "albumplay"
          swf_info["aid"]
        elsif url_type == "listplay"
          swf_info["lid"]
        end
      else
        page_match(/lid[\s|'|:]*(\S+)/)[1]
      end
    end

    def page_get_lcode
      if swf_iid
        if url_type == "albumplay" || url_type == "oplay"
          swf_info["aCode"]
        elsif url_type == "listplay"
          swf_info["lCode"]
        else
        end
      else
        page_match(/lcode[\s|'|:]*(\S+)'/)[1]
      end
    end

    def page_get_iid
      swf_iid || (page_match(/iid[\s|'|:]*(\S+)/)[1])
    end

    def page_get_icode
      if swf_iid
        if url_type == "oplay"
          swf_info["ablumItemCode"]
        else
          swf_info["code"]
        end
      else
        if url_type == "albumplay" || url_type == "listplay"
          item_info["code"]
        else
          page_match(/icode[\s|'|:]*(\S+)'/)[1]
        end
      end
    end

    def page_get_vcode
      if swf_iid
        swf_info["vcode"]
      else
        if url_type == "albumplay"
          item_info["vcode"]
        else
          page_match(/vcode[\s|'|:]*(\S+)'/)[1]
        end
      end
    end

    def page_get_title
      if swf_iid
        swf_info["title"]
      else
        if url_type == "albumplay" 
          item_info["albumItemShortDescription"]
        elsif url_type == "listplay"
          item_info["title"]
        else
          page_match(/,kw[\s|'|:]*(\S+.*)'/)[1] 
        end
      end
    end

    def page_get_pic
      if swf_iid
        swf_info["snap_pic"]
      else
        if url_type == "albumplay" || url_type == "listplay"
          item_info["picUrl"] 
        else
          page_match(/pic[\s|'|:]*(\S+)'/)[1]
        end
      end
    end

    def page_match(regex)
      data = page.match(regex)
      data || []
    end

    def view_media(type = nil)
      video_list = {}
      video_type = {
        "2" => "f4v_sd",
        "3" => "f4v_hd", 
        "4" => "f4v",
        "5" => "f4v_fhd",
        "52" => "mp4"
      }
      conn = Faraday.new "http://v2.tudou.com"
      conn.headers["User-Agent"] = ""
      response.each do |key, val|
        type = video_type[key] || key
        video_list[type] = []
        val.each do |video|
          video_list[type] << Getvideo::Response.new(conn.get("http://v2.tudou.com/f?id=#{video["k"]}", )).parsed["f"]["__content__"]
        end
      end
      return video_list
    end

    def albumplay_media(type = nil)
      video_list = {}
      response["data"][0]["streamfileids"].each_key do |type|
        stream = parse_stream(type)
        video_list[type] = []
        segs(type).each do |s|
          video_list[type] << "http://f.youku.com/player/getFlvPath/sid/" + sid + "/st/#{type}/fileid/#{stream[0..8]+s["no"].to_i.to_s(16)+stream[10..-1]}_0#{s["no"].to_i.to_s(16)}?K="+s["k"] if s["k"] != -1
        end
      end
      return video_list
    end

    def sid
      Time.now.to_i.to_s + rand(10..99).to_s+ "1000" + rand(30..80).to_s+"00"
    end

    def segs(type)
      response["data"][0]["segs"][type]
    end

    def videoid
      response["data"][0]["videoid"]
    end

    def parse_stream(type)
      seed = response["data"][0]["seed"]
      stream_fileids = response["data"][0]["streamfileids"][type]
      random_text = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/\:._-1234567890'

      text = ""
      random_text.each_char do |t|
        seed = (seed * 211 + 30031) % 65536
        cuch = ((seed / 65536.0) * random_text.length).to_i 
        char = random_text[cuch]
        text = text + char 
        random_text = random_text.gsub(char, "")
      end

      real_text = ""
      stream_fileids.split("*").each do |s|
        real_text = real_text + text.to_s[s.to_i]
      end
      return real_text 
    end

    attr_accessor :page, :swf_iid, :url_type, :item_info, :swf_info
  end
end
