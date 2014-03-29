#coding:utf-8

module Getvideo
  class Youku < Video
    set_api_uri { "http://v.youku.com/player/getPlayList/VideoIDS/" + id }

    def id
      if url =~ /\.html/
        url.scan(/id_([^.]+)/)[0][0]
      elsif url =~ /\.swf/
        url.scan(/sid\/([^\/]+)\/v.swf/)[0][0]
      end
    end

    def html_url
      "http://v.youku.com/v_show/id_#{id}.html"
    end

    def title
      if data = response["data"]
        data[0]["title"]
      end
    end

    def cover
      if data = response["data"]
        data[0]["logo"]
      end
    end

    def flash
      "http://player.youku.com/player.php/sid/#{id}/v.swf"
    end

    def m3u8
      "http://v.youku.com/player/getM3U8/vid/#{videoid}/type/flv/ts/v.m3u8" 
    end

    def media(type = nil)
      video_list = {}
      if data = response["data"]
        data[0]["streamfileids"].each_key do |type|
          stream = parse_stream(type)
          video_list[type] = []
          segs(type).each do |s|
            video_list[type] << "http://f.youku.com/player/getFlvPath/sid/" + sid + "/st/#{type}/fileid/#{stream[0..8]+s["no"].to_i.to_s(16)+stream[10..-1]}_0#{s["no"].to_i.to_s(16)}?K="+s["k"] if s["k"] != -1
          end
        end
      end
      return video_list
    end

    private

    def sid
      Time.now.to_i.to_s + rand(10..99).to_s+ "1000" + rand(30..80).to_s+"00"
    end

    def segs(type)
      response["data"][0]["segs"][type]
    end

    def videoid
      if data = response["data"]
        data[0]["videoid"]
      end
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
  end
end
