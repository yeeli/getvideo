#coding:utf-8

module Getvideo
  class Iqiyi < Video
    set_api_uri { "http://cache.video.qiyi.com/v/#{id}" }

    def ipad_response
      @ipad_response ||= ipad_connection
    end

    def html_url
      response_info["videoUrl"]
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
      response_info["title"]
    end

    def cover
      response_info["albumImage"]
    end

    def m3u8
      ipad_response["data"]["mtl"][1]["m3u"]
    end

    def flash
      position = response_info["logoPosition"]
      duration = response_info["totalDuration"]
      video_url =  response_info["videoUrl"].gsub("http://www.iqiyi.com/","")
      "http://player.video.qiyi.com/#{id}/#{position}/#{duration}/#{video_url}"[0..-5]+"swf"
    end

    def media
      video_list = {}
      video_list["mp4"] = []
      video_list["f4v"] = []
      mp4_file = ipad_response["data"]["mp4Url"]
      res  = Faraday.get "http://data.video.qiyi.com/#{mp4_file.split("/")[-1].split(".")[0]}.ts"
      video_list["mp4"] << "#{mp4_file}?#{URI.parse(res["location"]).query}"
      file = response_info["fileUrl"]["file"]
      size = response_info["fileBytes"]["size"]
      file.each_with_index do |f, i|
        res  = Faraday.get "http://data.video.qiyi.com/#{file[i].split("/")[-1].split(".")[0]}.ts"
        video_list["f4v"] << "#{f}?#{URI.parse(res["location"]).query}"
      end
      return  video_list
    end

    private

    def ipad_connection
      conn = Faraday.new "http://cache.video.qiyi.com"
      conn.headers["User-Agent"] = ""
      response= conn.get "/m/#{id}/"
      MultiJson.load response.body.scan(/ipadUrl=([^*]+)/)[0][0]
    end

    def parse_vid
      conn = Faraday.new
      page_res = conn.get(url)
      return page_res.body.match(/data-player-videoid\s*[:=]\s*["']([^"']+)["']/)
    end

    def response_info
      response["root"]["video"]
    end
  end
end
