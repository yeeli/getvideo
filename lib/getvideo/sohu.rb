#coding:utf-8

module Getvideo
  class Sohu
   def initialize(uri)
     @url = uri
     @site = "http://hot.vrs.sohu.com/vrs_flash.action"
     @body = JSON.parse(response)
   end

   def url=(param)
     @url = param
   end

   def url
     @url
   end

   def id
     parse_vid[1]
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

   def flv
     host = @body["allot"]
     prot = @body["prot"]
     clips = @body["data"]["clipsURL"]
     new = @body["data"]["su"]
     clips_len = clips.length
     new_len = new.length
     video_list = []
     clips.zip(new).each do | c, n |
       h, _, _, key = Net::HTTP.get(URI.parse("http://#{host}?prot=#{prot}&file=#{c}&new=#{n}")).split("|")
       video_list << "#{h}#{n}?key=#{key}"
     end
     return video_list
   end

   private

   def info_path 
     @site + "?vid=#{id}"
   end

   def response
     uri = URI.parse(info_path)
     Net::HTTP.get(uri)
   end

   def parse_vid
     page_uri = URI.parse(url)
     page_doc = Net::HTTP.new(page_uri.host, page_uri.port)
     page_res = page_doc.get(page_uri.path)
     page_res.body.match(/vid="(\d+)"/)
   end
  end
end
