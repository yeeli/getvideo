require 'spec_helper'

describe Getvideo::Ku6 do
  let(:ku6){ Getvideo::Ku6.new("http://v.ku6.com/special/show_6584838/7qc3x3fB98cPpTD509x1OQ...html") }

  describe "#url" do
    it{ ku6.url.should == "http://v.ku6.com/special/show_6584838/7qc3x3fB98cPpTD509x1OQ...html" }
  end

  describe "#cover" do
    it{ ku6.cover.should =~ /ku6img\.com/ }
  end

  describe "#flash" do
    it{ ku6.flash.should == "http://player.ku6.com/refer/7qc3x3fB98cPpTD509x1OQ../v.swf" }
  end
  
  describe "#flv" do
    it{ ku6.flv.count.should equal(1) }
  end
end
