require 'spec_helper'

describe Getvideo::Youku do
  let(:youku){ Getvideo::Youku.new("http://v.youku.com/v_show/id_XNDQ2MzE4MzMy.html") }

  describe "#url" do
    it{ youku.url.should == "http://v.youku.com/v_show/id_XNDQ2MzE4MzMy.html" }
  end

  describe "#id" do
    it{ youku.id.should == "XNDQ2MzE4MzMy" }
  end

  describe "#cover" do
    it{ youku.cover.should =~ /ykimg\.com/ }
  end

  describe "#flash" do
    it { youku.flash.should ==  "http://player.youku.com/player.php/sid/XNDQ2MzE4MzMy/v.swf" }
  end

  describe "#flv" do
    it{ youku.flv.count.should equal(3) }
  end

  describe "#m3u8" do
    it{ youku.m3u8.should == "http://v.youku.com/player/getM3U8/vid/111579583/type/flv/ts/#{Time.now.to_i}/v.m3u8"  }
  end
end
