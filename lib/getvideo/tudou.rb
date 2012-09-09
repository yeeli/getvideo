
module Getvideo
  class Tudou
    def initialize(uri)
      @url = uri
      @site = "http://v2.tudou.com/v?it="
      @body = response.body
    end

    def url=(param)
      @url= param
    end

    def url
      @url
    end

    def cover
      @body.match(/lpic\s*=\s*(\S+)/)[1]
    end

    def flash
      "http://www.tudou.com/v/#{code}/v.swf"
    end

    def m3u8
      "http://m3u8.tdimg.com/#{iid[0,3]}/#{iid[3,3]}/#{iid[6,3]}/2.m3u8"
    end

    def flv
      flv_url = URI.parse "http://v2.tudou.com/v?it="+ iid
      http = Net::HTTP.new(flv_url.host,flv_url.port)
      req = Net::HTTP::Get.new(flv_url.request_uri,{"User-Agent"=> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_0) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.79 Safari/537.1"})
      res = http.request req
      flv_doc = Nokogiri::XML(res.body)
      video_list = []
      flv_doc.css("f").each do |f|
        video_list << f.content
      end
      return video_list
    end

    private

    def code
      @body.match(/icode\s*=\s*(\S+)/)[1]
    end

    def iid
      @body.match(/iid\s*=\s*(\S+)/)[1]
    end

    def response
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port) 
      res = http.get(uri.path)
    end
  end
end
