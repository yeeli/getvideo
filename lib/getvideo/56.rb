#coding:utf-8

module Getvideo 
  class Wole
    attr_reader :url

    def initialize(uri)
      @url = uri
      @site = "http://vxml.56.com/json/" 
      @body = JSON.parse(response)
    end

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
      @body["info"]["bimg"] if @body
    end

    def title
      @body["info"]["Subject"] if @body
    end

    def flash
      "http://player.56.com/v_#{id}.swf"
    end

    def m3u8
      "http://vxml.56.com/m3u8/#{@body["info"]["vid"]}/" if @body
    end

    def media
      video_list = {}
      @body["info"]["rfiles"].each do |f|
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
      @site + id + "/?src=site"
    end

    def response
      uri = URI.parse info_path
      http = Net::HTTP.new(uri.host, uri.port)
      res = http.get(uri.path)
      res.body
    end
  end
end
