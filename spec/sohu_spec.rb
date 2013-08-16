#coding:utf-8
require 'spec_helper'

describe Getvideo::Sohu do
  let(:sohu){ Getvideo::Sohu.new("http://tv.sohu.com/20120111/n331887864.shtml") }
  let(:sohu_swf){ Getvideo::Sohu.new("http://share.vrs.sohu.com/549836/v.swf&autoplay=false&xuid=") }
  let(:sohu_id){ Getvideo::Sohu.new("549836") }
  #let(:sohu_my){ Getvideo::Sohu.new("http://my.tv.sohu.com/u/pw/5085302_1_3") }
  let(:sohu_my){ Getvideo::Sohu.new("http://my.tv.sohu.com/pl/5085302/28323085.shtml") }
  #let(:sohu_my_u){ Getvideo::Sohu.new("http://my.tv.sohu.com/u/vw/32845325") }
  let(:sohu_my_u){ Getvideo::Sohu.new("http://my.tv.sohu.com/us/6562328/32845325.shtml") }
  let(:sohu_user_detail){ Getvideo::Sohu.new("http://my.tv.sohu.com/user/detail/90962205.shtml?pvid=22d90f5ff2caa66f")}
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
       sohu_my.id.should == "28323085" 
       sohu_my_u.id.should == "32845325" 
       sohu_my_swf.id.should == "32427841" 
       sohu_my_id.id.should == "32427841" 
       sohu_user_detail.id.should == "59344870"
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
    it "should return falsh" do 
      sohu.flash.should ==  "http://share.vrs.sohu.com/549836/v.swf&autoplay=false" 
      sohu_my.flash.should ==  "http://share.vrs.sohu.com/my/v.swf&topBar=1&id=28323085&autoplay=false" 
    end
  end

  describe "m3u8" do
    it{ sohu.m3u8.should ==  "http://hot.vrs.sohu.com/ipad549836.m3u8" }
  end

  describe "#media" do
    it{ sohu.media["mp4"].count.should be(20) }
  end
end
