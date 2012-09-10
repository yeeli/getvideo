require 'spec_helper'

describe Getvideo::Tudou do
  context "when get tudou programs" do
    let(:tudou){ Getvideo::Tudou.new("http://www.tudou.com/programs/view/-tuU-wryFaQ/") }

    describe "#url" do
      it{ tudou.url.should == "http://www.tudou.com/programs/view/-tuU-wryFaQ/" }
    end

    describe "#id" do
      it{ tudou.id.should == "151831829" }
    end

    describe "#cover" do
      it{ tudou.cover }
    end

    describe "#flash" do
      it { tudou.flash.should ==  "http://www.tudou.com/v/-tuU-wryFaQ/v.swf" }
    end

    describe "#flv" do
      it{ tudou.flv.count.should equal(4)}
    end

    describe "#m3u8" do
      it{ tudou.m3u8.should == "http://m3u8.tdimg.com/151/831/829/2.m3u8"  }
    end
  end

  context "when get tudou is /listplay/id/id.html" do
    let(:tudou){ Getvideo::Tudou.new("http://www.tudou.com/listplay/I5Slvt7SADI/v3iXUGwvvSc.html")}
    describe "#id" do
      it{ tudou.id.should == "151781698" }
    end

    describe "#flash" do
      it{ tudou.flash.should == "http://www.tudou.com/l/v3iXUGwvvSc/&iid=151781698/v.swf" }
    end
  end

  context "when tudou url is /listplay/id.htm" do
    let(:tudou){ Getvideo::Tudou.new("http://www.tudou.com/listplay/Vy38Ht1YfII.html")}

    describe "#id" do
      it{ tudou.id.should == "148207924" }
    end

    describe "#flash" do
      it{ tudou.flash.should == "http://www.tudou.com/l/DoISHyPOaPg/v.swf" }
    end
  end

  context "when tudou/url is /albumplay/p/id.html" do
  let(:tudou){ Getvideo::Tudou.new("http://www.tudou.com/albumplay/7CBVBQsTqVQ/Kctl_M-8ccs.html")}
    describe "#id" do
      it{ tudou.id.should == "151820922" }
    end

    describe "#flash" do
      it{ tudou.flash.should == "http://www.tudou.com/l/Kctl_M-8ccs/&iid=151820922/v.swf" }
    end
  end
end
