#coding:utf-8

module Getvideo 
  class Wole < Video
    set_api_uri { "http://vxml.56.com/json/#{id}/?src=site" }

    def html_url
      if url =~ /v_([^.]+).html/
        url
      else
        "http://www.56.com/u/v_#{id}.html"
      end
    end

    def id
      if url =~ /v_([^.]+).[html|swf]/
        url.scan(/v_([^.]+)\.[html|swf]/)[0][0]
      elsif url =~ /w.+\/play_album.+_vid-([^.]+)\.html/
        ids = url.scan /w.+\/play_album.+_vid-([^.]+)\.html/
        ids[0][0]
      else
        url
      end
    end

    def cover
      response["info"]["bimg"] if response
    end

    def title
      response["info"]["Subject"] if response
    end

    def flash
      "http://player.56.com/v_#{id}.swf"
    end

    def m3u8
      "http://vxml.56.com/m3u8/#{response["info"]["vid"]}/" if response
    end

    def media
      video_list = {}
      response["info"]["rfiles"].each do |f|
        f_type = f["url"].scan(/\.(flv|mp4|m3u8)\?/)[0][0]
        if video_list[f_type].nil?
          video_list[f_type] = []
          video_list[f_type] << f["url"] 
        else
          video_list[f_type] << f["url"]
        end
      end
      return video_list
    end

    def play_media
      media["mp4"][0] if media["mp4"]
    end
  end
end
