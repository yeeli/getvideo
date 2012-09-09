require 'spec_helper'

describe Getvideo::Sohu do
  let(:sohu){ Getvideo::Sohu.new("http://tv.sohu.com/20120111/n331887864.shtml") }
  describe "#id" do
    it{ sohu.id.should == "549836" }
  end

  describe "#cover" do
    it{ sohu.cover.should match(/photocdn\.sohu\.com/) }
  end

  describe "#flash" do
    it{ sohu.flash.should ==  "http://share.vrs.sohu.com/my/v.swf&topBar=1&id=549836&autoplay=false" }
  end

  describe "m3u8" do
    it{ sohu.m3u8.should ==  "http://my.tv.sohu.com/ipad/549836.m3u8" }
  end

  describe "#flv" do
    it{ sohu.flv.count.should equal(20) }
  end
end
