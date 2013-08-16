require 'spec_helper'

describe Getvideo::Wole do
  let(:wole){ Getvideo::Wole.new("http://www.56.com/u97/v_NzIzOTUxMzQ.html") }
  let(:wole_album) { Getvideo::Wole.new "http://www.56.com/w83/play_album-aid-10272986_vid-NzYxMTk0Nzg.html"}
  let(:wole_swf){ Getvideo::Wole.new("http://player.56.com/v_NzIzOTUxMzQ.swf")}
  let(:wole_id){ Getvideo::Wole.new("NzIzOTUxMzQ")}

  describe "#html_url" do
    context "when html url" do
      it{ wole.html_url.should == "http://www.56.com/u97/v_NzIzOTUxMzQ.html" }
    end

    context "when swf url" do
      it "should return url" do 
        wole_swf.html_url.should == "http://www.56.com/u/v_NzIzOTUxMzQ.html"
        wole_id.html_url.should == "http://www.56.com/u/v_NzIzOTUxMzQ.html"
      end
    end
  end

  describe "#id" do
    it "shold return url" do
      wole.id.should == "NzIzOTUxMzQ"
      wole_album.id.should == "NzYxMTk0Nzg"
      wole_swf.id.should == "NzIzOTUxMzQ"
      wole_id.id.should == "NzIzOTUxMzQ"
    end
  end

  describe "#title" do
    it{ wole.title.should match(/20120906/) }
  end

  describe "#cover" do
    it{ wole.cover.should match(/v19.56img.com/) }
  end

  describe "#flash" do
    it{ wole.flash.should == "http://player.56.com/v_NzIzOTUxMzQ.swf" }
  end

  describe "#media" do
    it{ wole.media["flv"].count.should be(3) }
  end
  
  describe "#m3u8" do
    it{ wole.m3u8.should == "http://vxml.56.com/m3u8/72395134/" }
  end
end
