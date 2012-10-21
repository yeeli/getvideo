require 'spec_helper'

describe Getvideo::Wole do
  let(:wole){ Getvideo::Wole.new("http://www.56.com/u97/v_NzIzOTUxMzQ.html") }
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
      wole_swf.id.should == "NzIzOTUxMzQ"
      wole_id.id.should == "NzIzOTUxMzQ"
    end
  end

  describe "#title" do
    it{ wole.title.should match(/20120906/) }
  end

  describe "#cover" do
    it{ wole.cover.should match(/v19.56.com/) }
  end

  describe "#flash" do
    it{ wole.flash.should == "http://player.56.com/v_NzIzOTUxMzQ.swf" }
  end

  describe "#media" do
    it{ wole.media["flv"].count.should be(2) }
  end
end
