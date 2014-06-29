#coding:utf-8
require 'digest/md5'

module Getvideo
  class Sina < Video
    set_api_uri do
      rand = "0.#{rand(10000..10000000)}#{rand(10000..10000000)}"
      "http://v.iask.com/v_play.php?vid=#{id}&ran=#{rand}&p=i&k=#{get_k(id, rand)}" 
    end

    def ipad_response
      @ipad_response ||= ipad_connection
    end

    def initialize(url)
      super
      parse_page if !(is_flash_url? || is_subject_url?)
    end

    def id
      return url.match(/vid=(\d+)/).to_a[1] if is_flash_url?
      return url.match(/#(\d+)/).to_a[1] if is_subject_url?
      page.match(/vid[\s]*:[\s]*["|']?[\s]*(\d+)[\s]*["|']?/).to_a[1]
    end

    def cover
      return "" if is_flash_url? || is_subject_url?
      page.match(/pic[\s]*:[\s]*["|']?[\s]*([^'|"]+)?/).to_a[1]
    end

    def html_url
      return "" if is_flash_url?
      url
    end

    def title
      response["video"]["vname"]
    end

    def flash
      return url if is_flash_url?
      return "" if is_subject_url?
      return "" if !page
      page.match(/swfOutsideUrl[\s]*:[\s]*["|']?[\s]*([^'|"]+)/).to_a[1]
    end

    def m3u8
      if !(is_flash_url? || is_subject_url?)
        ipad_response["video"]["durl"]["url"]
      else
        ""
      end
    end

    def media
      video_list = {}
      if !(is_flash_url? || is_subject_url?)
        video_list["mp4"] = []
        video_list["mp4"] << ipad_response["video"]["durl"]["url"]
      end
      video_list["hlv"] = []
      video_list["hlv"] << response["video"]["durl"]["url"]
      return video_list
    end

    private

    def ipad_connection
      rand = "0.#{rand(10000..10000000)}#{rand(10000..10000000)}"
      Response.new(Faraday.get("http://v.iask.com/v_play.php?vid=#{ipad_vid}&ran=#{rand}&p=i&k=#{get_k(ipad_vid, rand)}")).parsed
    end

    def get_k(vid, rand)
      t = Time.now.to_i.to_s(2)[0..-7].to_i(2)
      Digest::MD5.hexdigest("#{vid.to_s}Z6prk18aWxP278cVAH#{t.to_s}#{rand.to_s}".encode('utf-8'))[0..15] + t.to_s
    end

    def is_flash_url?
      url =~ /\.swf/ 
    end

    def is_subject_url?
      url =~ /#\d+/
    end

    def parse_page
      page_res = Faraday.get(url)
      @page = page_res.body
      @ipad_vid = page.match(/ipad_vid[\s]*:[\s]*["|']?[\s]*(\d+)[\s]*["|']?/).to_a[1]
    end

    attr_accessor :page, :ipad_vid
  end
end
