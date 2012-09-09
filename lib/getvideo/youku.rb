#coding:utf-8

module Getvideo
  class Youku
    def initialize(uri)
      @url = uri
      @site = "http://v.youku.com/player/getPlayList/VideoIDS/" 

      @body = JSON.parse(response.body)
    end

    def url=(param)
      @url= param
    end

    def url
      @url
    end


    def id
      @url.split("/").last.split(".")[0].delete("id_")
    end

    def cover
      @body["data"][0]["logo"]
    end


    def flash
      "http://player.youku.com/player.php/sid/#{id}/v.swf"
    end

    def m3u8
      "http://v.youku.com/player/getM3U8/vid/#{videoid}/type/flv/ts/#{Time.now.to_i}/v.m3u8" 
    end

    def flv
      type = "flv"
      stream = parse_stream(type)
      video_list = []
      segs(type).each do |s|
        video_list << "http://f.youku.com/player/getFlvPath/sid/"+sid+"/st/#{type}/fileid/#{stream[0..8]+s["no"].to_i.to_s(16)+stream[10..-1]}_0#{s["no"].to_i.to_s(16)}?K="+s["k"]
      end
      return video_list
    end


    private
    def info_path
      @site + id
    end

    def sid
      Time.now.to_i.to_s + rand(10..99).to_s+ "1000" + rand(30..80).to_s+"00"
    end

    def segs(type)
      @body["data"][0]["segs"][type]
    end

    def videoid
      @body["data"][0]["videoid"]
    end

    def response
      uri = URI.parse(info_path)
      http = Net::HTTP.new(uri.host, uri.port)
      res = http.get(uri.path)
    end

    def parse_stream(type)
      seed = @body["data"][0]["seed"]
      stream_fileids = @body["data"][0]["streamfileids"][type]
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
