require 'spec_helper'

describe Getvideo::Youtube do
  let(:youtube){ Getvideo::Youtube.new "http://www.youtube.com/watch?v=ylLzyHk54Z0" }
  let(:youtube2){ Getvideo::Youtube.new "http://www.youtube.com/watch?v=S0o4-efO9x4&feature=g-vrec" }
  let(:youtube3){ Getvideo::Youtube.new "http://www.youtube.com/watch?v=pI47zdMhX3I" }
  let(:youtube_s){ Getvideo::Youtube.new "http://youtu.be/ylLzyHk54Z0" }
  let(:youtube_id){ Getvideo::Youtube.new "ylLzyHk54Z0" }
  let(:youtube_swf){ Getvideo::Youtube.new "http://www.youtube.com/v/ylLzyHk54Z0" }
  
  describe "#id" do
    it "should return id" do
      youtube.id.should == "ylLzyHk54Z0"
      youtube2.id.should == "S0o4-efO9x4"
      youtube3.id.should == "pI47zdMhX3I"
      youtube_swf.id.should == "ylLzyHk54Z0"
      youtube_s.id.should == "ylLzyHk54Z0"
      youtube_id.id.should == "ylLzyHk54Z0"
    end
  end

  describe "#html_url" do
    it "should return html url" do
      youtube_swf.html_url.should == "http://www.youtube.com/watch?v=ylLzyHk54Z0"
      youtube_id.html_url.should == "http://www.youtube.com/watch?v=ylLzyHk54Z0"
    end
  end

  describe "#cover" do
    it{ youtube.cover.should =~ /ytimg/}
  end

  describe "#flash" do
    it{ youtube.flash.should == "http://www.youtube.com/v/ylLzyHk54Z0"}
  end

  describe "#cover" do
    it{ youtube.cover.should == "http://i2.ytimg.com/vi/ylLzyHk54Z0/0.jpg"}
  end

  describe "#title" do
   it{ youtube.title.should match(/API/)}
   it{ youtube3.title.should match(/API/)}
  end

  describe "#m3u8" do
   it{ youtube.m3u8.should match(/youtube\.com/)}
  end

  describe "media" do
    it{ youtube.media["flv"][0].should match(/youtube\.com/)}
  end
end
