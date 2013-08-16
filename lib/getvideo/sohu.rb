#coding:utf-8

module Getvideo
  class Sohu < Video
    set_api_uri do
      if url =~ /(my\.tv|my\/v\.swf|\|my)/
        "http://my.tv.sohu.com/videinfo.jhtml?m=viewnew&vid=#{id}"
      else
        "http://hot.vrs.sohu.com/vrs_flash.action?vid=#{id}"
      end
    end

    def html_url
      response["url"]
    end

    def id
      if url =~ /my\.tv.+\/(?:pl|us)\/(?:[^\D]+)\/([^\D]+)/
        u = url.scan(/my\.tv.+\/(?:pl|us)\/(?:[^\D]+)\/([^\D]+)/)[0][0]
      elsif url =~ /(\.shtml|my\.tv.+\/user\/detail)/
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
      response["data"]["tvName"]
    end

    def cover
      response["data"]["coverImg"]
    end

    def flash
      if url =~ /(my\.tv)/
        "http://share.vrs.sohu.com/my/v.swf&topBar=1&id=#{id}&autoplay=false"
      else
        "http://share.vrs.sohu.com/#{id}/v.swf&autoplay=false"
      end
    end

    def m3u8
      if url =~ /(my\.tv)/
        "http://my.tv.sohu.com/ipad/#{id}.m3u8"
      else
        "http://hot.vrs.sohu.com/ipad#{id}.m3u8"
      end
    end

    def media
      host = response["allot"]
      prot = response["prot"]
      clips = response["data"]["clipsURL"]
      new = response["data"]["su"]
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

    def parse_vid
      conn = Faraday.new
      page_res = conn.get(url)
      page_res.body.match(/vid[\s]*=[\s]*["|']?(\d+)["|']?/)
    end
  end
end
