require 'spec_helper'

describe Getvideo::Wole do
  let(:wole){ Getvideo::Wole.new("http://www.56.com/u97/v_NzIzOTUxMzQ.html") }

  describe "#url" do
    it{ wole.url.should == "http://www.56.com/u97/v_NzIzOTUxMzQ.html" }
  end

  describe "#cover" do
    it{ wole.cover.should =~ /img/}
  end

  describe "#flash" do
    it{ wole.flash.should == "http://player.56.com/v_NzIzOTUxMzQ.swf" }
  end

  describe "#flv" do
    it{ wole.flv.count.should equal(1) }
  end
end
