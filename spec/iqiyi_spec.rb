#coding:utf-8
require 'spec_helper'

describe Getvideo::Iqiyi do
  let(:iqiyi){ Getvideo::Iqiyi.new("http://www.iqiyi.com/weidianying/20120925/f15221a897037d07.html")}

  let(:iqiyi_swf){ Getvideo::Iqiyi.new("http://player.video.qiyi.com/38c130b7b4124b1e902161e8e377324b/0/649/weidianying/20120925/f15221a897037d07.swf-pid=47084-ptype=2-albumId=233012-tvId=280286")}

  let(:iqiyi_id){ Getvideo::Iqiyi.new("38c130b7b4124b1e902161e8e377324b")}

  describe "#id" do
    it "should return id" do
      iqiyi.id.should == "38c130b7b4124b1e902161e8e377324b"
      iqiyi_swf.id.should == "38c130b7b4124b1e902161e8e377324b"
      iqiyi_id.id.should == "38c130b7b4124b1e902161e8e377324b"
    end
  end

  describe "#url" do
    it{iqiyi.html_url.should eq("http://www.iqiyi.com/weidianying/20120925/f15221a897037d07.html")}
  end

  describe "#title" do
    it{ iqiyi.title.should match(/网络/)}
  end
  describe "#m3u8" do
    it{ iqiyi.m3u8.should == "http://meta.video.qiyi.com/158/e5c6fe204412ee9b0f07e1cd62dba0cf.m3u8" }
  end

  describe "#flash" do
    it{ iqiyi.flash.should == "http://player.video.qiyi.com/38c130b7b4124b1e902161e8e377324b/0/649/weidianying/20120925/f15221a897037d07.swf" }
  end

  describe "#media" do
    it{ iqiyi.media["ts"].count.should be(2) }
  end

  describe "#cover" do
    it{ iqiyi.cover.should =~ /qiyipic\.com/ }
  end
end
