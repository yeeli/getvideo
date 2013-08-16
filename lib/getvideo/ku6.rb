#coding:utf-8

module Getvideo
  class Ku6 < Video
    def html_url
      if url =~ /\.html/
        url
      else
        "http://v.ku6.com/show/#{id}.html"
      end
    end

    def title
      response["data"]["t"]
    end

    def id
      if url =~ /\.html/
        url.split("/").last.split(".html")[0]
      elsif url =~ /\.swf/
        url.split("/")[-2]
      else
        url
      end
    end

    def cover
      response["data"]["bigpicpath"]
    end

    def flash
      "http://player.ku6.com/refer/#{id}/v.swf"
    end

    def m3u8
      "http://v.ku6.com/fetchwebm/#{id}.m3u8"
    end

    def media
      video_list = {}
      video_list["f4v"] = []
      response["data"]["f"].split(",").each do |f|
        video_list["f4v"] << f
      end
      return video_list
    end

    private

    def connection
      conn = Faraday.new
      response= conn.post "http://v.ku6.com/fetch.htm", {"t" => "getVideo4Player", "vid" => id} 
      @response = Response.new(response).parsed
    end
  end
end
