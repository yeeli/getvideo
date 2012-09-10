#coding:utf-8

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
      if url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/
        "http://www.tudou.com/l/#{code}/&iid=#{iid}/v.swf"
      elsif  url =~ /\/listplay\/([^.]+)\.html/
        "http://www.tudou.com/l/#{code}/v.swf"
      else
        "http://www.tudou.com/v/#{code}/v.swf"
      end
    end

    def m3u8
      "http://m3u8.tdimg.com/#{iid[0,3]}/#{iid[3,3]}/#{iid[6,3]}/2.m3u8"
    end

    def flv
      flv_url = URI.parse "http://v2.tudou.com/v?it=#{iid}&st=1,2,3,4,99"
      http = Net::HTTP.new(flv_url.host,flv_url.port)
      req = Net::HTTP::Get.new(flv_url.request_uri,{"User-Agent"=> ""})
      res = http.request req
      flv_doc = Nokogiri::XML(res.body)
      video_list = []
      flv_doc.css("f").each do |f|
        video_list << f.content
      end
      return video_list
    end

    def id
      iid
    end

    private

    def code
      if url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/
        url.scan(/\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/)[0][2]
      elsif url =~ /\/listplay\/([^.]+)\.html/
        @body.match(/icode\s*:\s*\"(\S+)\"/)[1]
      else
        @body.match(/icode\s*=\s*'(\S+)'/)[1]
      end
    end

    def iid
      if url =~ /\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/
        icode = url.scan(/\/(listplay|albumplay|oplay)\/([^.]+)\/([^.]+)\.html/)
        return get_iid(icode[0][2])
      elsif url =~ /\/listplay\/([^.]+)\.html/
        icode = url.scan(/\/listplay\/([^.]+)\.html/)
        script =  @body.match(/<script>([^*]+)<\/script>/)[1]
        script.match(/iid\s*:\s*(\S+)/)[1]
      else
        @body.match(/iid\s*=\s*(\S+)/)[1]
      end
    end

    def get_iid(icode)
      script =  @body.match(/<script>([^*]+)<\/script>/)[1]
      icode_list = script.scan(/icode\s*:\s*\"(\S+)\"/)
      iid_list = script.scan(/iid\s*:\s*(\S+)/)
      num = icode_list.index([icode])
      iid_list[num][0]
    end

    def response
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port) 
      res = http.get(uri.path)
    end
  end
end
