#coding:utf-8
require 'spec_helper'

describe Getvideo::Sohu do
  let(:sohu){ Getvideo::Sohu.new("http://tv.sohu.com/20120111/n331887864.shtml") }
  let(:sohu_swf){ Getvideo::Sohu.new("http://share.vrs.sohu.com/549836/v.swf&autoplay=false&xuid=") }
  let(:sohu_id){ Getvideo::Sohu.new("549836") }
  let(:sohu_my){ Getvideo::Sohu.new("http://my.tv.sohu.com/u/pw/5085302_1_3") }
  let(:sohu_my_swf){ Getvideo::Sohu.new("http://share.vrs.sohu.com/my/v.swf&autoplay=false&id=32427841&skinNum=1&topBar=1&xuid=") }
  let(:sohu_my_id){ Getvideo::Sohu.new("32427841|my") }
  
  describe "#id" do
    context "when is tv.sohu.com" do
      it "should return id" do
         sohu.id.should == "549836" 
         sohu_swf.id.should == "549836" 
         sohu_id.id.should == "549836" 
      end
    end

    context "when is my.tv.sohu.com" do
      it "should return id" do
       sohu_my.id.should == "32427841" 
       sohu_my_swf.id.should == "32427841" 
       sohu_my_id.id.should == "32427841" 
      end
    end
  end

  describe "#html_url" do
    it{sohu.html_url.should == "http://tv.sohu.com/20120111/n331887864.shtml"}
  end

  describe "title" do
   it{ sohu.title.should match(/怒火/)}
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

  describe "#media" do
    it{ sohu.media["mp4"].count.should be(20) }
  end
end
