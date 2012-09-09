require 'spec_helper'

describe Getvideo::Tudou do
  context "when get tudou programs" do
    let(:tudou){ Getvideo::Tudou.new("http://www.tudou.com/programs/view/-tuU-wryFaQ/") }

    describe "#url" do
      it{ tudou.url.should == "NDQ2MzE4MzMy.html" }
    end

    describe "#id" do
      it{ tudou.id.should == "" }
    end

    describe "#cover" do
      it{ puts tudou.cover }
    end

    describe "#flash" do
      it { tudou.flash.should ==  "" }
    end

    describe "#flv" do
      it{ tudou.flv.count.should equal(3) }
    end

    describe "#m3u8" do
      it{ tudou.m3u8.should == ""  }
    end
  end
  context "when get tudou list" do
  end
end
