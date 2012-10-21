require 'spec_helper'

describe Getvideo::Ku6 do
  let(:ku6){ Getvideo::Ku6.new("http://v.ku6.com/special/show_6584838/7qc3x3fB98cPpTD509x1OQ...html") }
  let(:ku6_swf){ Getvideo::Ku6.new("http://player.ku6.com/refer/7qc3x3fB98cPpTD509x1OQ../v.swf") }
  let(:ku6_id){ Getvideo::Ku6.new("7qc3x3fB98cPpTD509x1OQ..") }

  describe "#id" do
    it "shouw return id" do
    ku6.id.should == "7qc3x3fB98cPpTD509x1OQ.." 
    ku6_swf.id.should == "7qc3x3fB98cPpTD509x1OQ.." 
    ku6_id.id.should == "7qc3x3fB98cPpTD509x1OQ.." 
    end
  end

  describe "#title" do
    it{ ku6.title.should match(/MV/)}
  end

  describe "#html_url" do
    it "should return url" do
      ku6.html_url.should == "http://v.ku6.com/special/show_6584838/7qc3x3fB98cPpTD509x1OQ...html"
      ku6_swf.html_url.should == "http://v.ku6.com/show/7qc3x3fB98cPpTD509x1OQ...html"
      ku6_swf.html_url.should == "http://v.ku6.com/show/7qc3x3fB98cPpTD509x1OQ...html"
    end
  end

  describe "#cover" do
    it{ ku6.cover.should =~ /ku6img\.com/ }
  end

  describe "#flash" do
    it{ ku6.flash.should == "http://player.ku6.com/refer/7qc3x3fB98cPpTD509x1OQ../v.swf" }
  end
  
  describe "#media" do
    it{ ku6.media["f4v"].count.should equal(1) }
  end
end
