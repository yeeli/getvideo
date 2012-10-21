#coding:utf-8

module Getvideo
  class Sohu
   attr_accessor :url

   def initialize(uri)
     @url = uri
     @site = "http://hot.vrs.sohu.com/vrs_flash.action"
     @site2 = "http://my.tv.sohu.com/videinfo.jhtml"
     @body = JSON.parse(response)
   end

   def html_url
     @body["url"]
   end

   def id
     if url =~ /(\.shtml|my\.tv)/
       parse_vid[1]
     elsif url =~ /v\.swf/
       url.scan(/(sohu\.com\/([^\D]+)\/v.swf|id=([^\D]+))/)[0].compact[1]
     elsif url =~ /\|my/
       url.split("|")[0]
     else
       url
     end
   end

   def title
     @body["data"]["tvName"]
   end

   def cover
     @body["data"]["coverImg"]
   end

   def flash
     "http://share.vrs.sohu.com/my/v.swf&topBar=1&id=#{id}&autoplay=false"
   end

   def m3u8
     "http://my.tv.sohu.com/ipad/#{id}.m3u8"
   end

   def media
     host = @body["allot"]
     prot = @body["prot"]
     clips = @body["data"]["clipsURL"]
     new = @body["data"]["su"]
     clips_len = clips.length
     new_len = new.length
     video_list = {}
     video_list["mp4"] = []
     clips.zip(new).each do | c, n |
       h, _, _, key = Net::HTTP.get(URI.parse("http://#{host}?prot=#{prot}&file=#{c}&new=#{n}")).split("|")
       video_list["mp4"] << "#{h}#{n}?key=#{key}"
     end
     return video_list
   end

   def play_media
     media["mp4"]
   end

    def json
     if url =~ /(my\.tv|my\/v\.swf)/
       id_code = id + "|my"
     end

      {id: id_code,
       url: html_url,
       cover: cover,
       title: title,
       m3u8: m3u8,
       flash: flash,
       media: play_media}.to_json
    end


   private

   def info_path 
     if url =~ /(my\.tv|my\/v\.swf|\|my)/
       @site2 + "?m=viewnew&vid=#{id}"
     else
       @site + "?vid=#{id}"
     end
   end

   def response
     uri = URI.parse(info_path)
     Net::HTTP.get(uri)
   end

   def parse_vid
     page_uri = URI.parse(url)
     page_doc = Net::HTTP.new(page_uri.host, page_uri.port)
     page_res = page_doc.get(page_uri.path)
     page_res.body.match(/vid=["|']?(\d+)["|']?/)
   end
  end
end
