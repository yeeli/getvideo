#coding:utf-8

module Getvideo
  class Pptv
    def initizlize(uri)
      @url = uri
      @site = "http://web-play.pptv.com"
      @body = Nokigiri::XML(resposne)
    end

    def url=(param)
      @url= param
    end

    def url
      @url
    end

    private

    def response
      uri = URI.parse(url)
      id = Net.HTTP.get
    end
  end
end
