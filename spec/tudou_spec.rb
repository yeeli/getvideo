require 'spec_helper'

describe Getvideo::Tudou do
  context "when url type view" do
    let(:tudou_v){Getvideo::Tudou.new "http://www.tudou.com/programs/view/-tuU-wryFaQ/"}
    let(:tudou_v_swf){Getvideo::Tudou.new "http://www.tudou.com/v/-tuU-wryFaQ/&rpid=116105338&resourceId=116105338_04_05_99/v.swf"}
    let(:tudou_dp_v){Getvideo::Tudou.new "dp.tudou.com/v/-tuU-wryFaQ.html"}
    let(:tudou_dp_v_swf){Getvideo::Tudou.new "http://dp.tudou.com/nplayer.swf?151831829&&33.439"}
    let(:tudou_dp_v_html){Getvideo::Tudou.new "http://dp.tudou.com/player.php?id=151831829&offset=1.733"}

    describe "#id" do
      it "should return id" do
        tudou_v.id.should == "151831829"
        tudou_v_swf.id.should == "151831829"
        tudou_dp_v.id.should == "151831829"
        tudou_dp_v_swf.id.should == "151831829"
        tudou_dp_v_html.id.should == "151831829"
      end
    end

    describe "#html_url" do
      it "should return html url" do
        tudou_v_swf.html_url.should == "http://www.tudou.com/programs/view/-tuU-wryFaQ/"
        tudou_dp_v.html_url.should == "http://www.tudou.com/programs/view/-tuU-wryFaQ/"
      end
    end

    describe "#flash" do
      it "should return flash url" do
        tudou_v.flash.should == "http://www.tudou.com/v/-tuU-wryFaQ/&rpid=116105338&resourceId=116105338_04_05_99/v.swf"
        tudou_dp_v.flash.should == "http://www.tudou.com/v/-tuU-wryFaQ/&rpid=116105338&resourceId=116105338_04_05_99/v.swf"
      end
    end

    describe "#title" do
      it {tudou_v.title.should match(/20120907/) }
    end

    describe "#cover" do
      it{ tudou_v.cover.should match(/tdimg/) }
    end

    describe "#m3u8" do
      it{ tudou_v.m3u8.should == "http://m3u8.tdimg.com/151/831/829/2.m3u8"  }
    end

    describe "#media" do
      it{ tudou_v.media["f4v"].count.should be(2)}
    end
  end

  context "when url type is albumplay" do
    let(:tudou_a){Getvideo::Tudou.new "http://www.tudou.com/albumplay/o8k8lTglGRw.html"}
    #会跳转url
    let(:tudou_a1){Getvideo::Tudou.new "http://www.tudou.com/albumplay/1D9nGd3U0ks/WjNmtxWnbac.html"}
    let(:tudou_a_swf){Getvideo::Tudou.new "http://www.tudou.com/a/o8k8lTglGRw/&rpid=116105338&resourceId=116105338_04_05_99&iid=64374265/v.swf"}
    let(:tudou_a2){Getvideo::Tudou.new "http://www.tudou.com/albumplay/o8k8lTglGRw/rbt0q3crEgs.html"}
    let(:tudou_a2_swf){Getvideo::Tudou.new "http://www.tudou.com/a/o8k8lTglGRw/&rpid=116105338&resourceId=116105338_04_05_99&iid=53568937/v.swf"}
    let(:tudou_dp_a){Getvideo::Tudou.new "http://dp.tudou.com/a/o8k8lTglGRw.html"}
    let(:tudou_dp_a2){Getvideo::Tudou.new "http://dp.tudou.com/a/o8k8lTglGRw/rbt0q3crEgs.html"}

    describe "#id" do
      it "should return id" do
        tudou_a.id.should == "64374265"
        tudou_a_swf.id.should == "64374265"
        tudou_a2.id.should == "53568937"
        tudou_a2_swf.id.should == "53568937"
        tudou_dp_a.id.should == "64374265"
        tudou_dp_a2.id.should == "53568937"
      end
    end

    describe "#html_url" do
      it "should return id" do
        tudou_a_swf.html_url.should == "http://www.tudou.com/albumplay/o8k8lTglGRw/t5Z2nRSE4yk.html"
        tudou_a2_swf.html_url.should == "http://www.tudou.com/albumplay/o8k8lTglGRw/rbt0q3crEgs.html"
        tudou_dp_a.html_url.should == "http://www.tudou.com/albumplay/o8k8lTglGRw.html"
        tudou_dp_a2.html_url.should == "http://www.tudou.com/albumplay/o8k8lTglGRw/rbt0q3crEgs.html"
      end
    end

    describe "#flash" do
      it "should return flash" do
        tudou_a.flash.should == "http://www.tudou.com/a/o8k8lTglGRw/&rpid=116105338&resourceId=116105338_04_05_99&iid=64374265/v.swf"
        tudou_a2.flash.should == "http://www.tudou.com/a/o8k8lTglGRw/&rpid=116105338&resourceId=116105338_04_05_99&iid=53568937/v.swf"
        tudou_dp_a.flash.should == "http://www.tudou.com/a/o8k8lTglGRw/&rpid=116105338&resourceId=116105338_04_05_99&iid=64374265/v.swf"
        tudou_dp_a2.flash.should == "http://www.tudou.com/a/o8k8lTglGRw/&rpid=116105338&resourceId=116105338_04_05_99&iid=53568937/v.swf"
      end
    end
    
    describe "#cover" do
      it "should return cover" do 
        tudou_a.cover.should match(/tdimg/) 
        tudou_a1.cover.should match(/tdimg/) 
      end
    end

    describe "#media" do
      it "return media url" do
        tudou_a.media["f4v"].count.should be(1)
        tudou_a.media["flv"].count.should be(1)
      end
    end
  end

  context "when url type is playlist" do
    let(:tudou_l){Getvideo::Tudou.new "http://www.tudou.com/listplay/ofVJWe0u0sI.html"}
    let(:tudou_l_swf){Getvideo::Tudou.new "http://www.tudou.com/l/ofVJWe0u0sI/&rpid=116105338&resourceId=116105338_04_05_99&iid=126315712/v.swf"}
    let(:tudou_l2){Getvideo::Tudou.new "http://www.tudou.com/listplay/ofVJWe0u0sI/_4805-g0kM8.html"}
    let(:tudou_l2_swf){Getvideo::Tudou.new "http://www.tudou.com/l/ofVJWe0u0sI/&rpid=116105338&resourceId=116105338_04_05_99&iid=126330996/v.swf"}
    let(:tudou_dp_l){Getvideo::Tudou.new "http://dp.tudou.com/l/ofVJWe0u0sI.html"}
    let(:tudou_dp_l2){Getvideo::Tudou.new "http://dp.tudou.com/l/ofVJWe0u0sI/_4805-g0kM8.html"}

    describe "#id" do
      it "should return id" do
        tudou_l.id.should == "126315712"
        tudou_l_swf.id.should == "126315712"
        tudou_l2.id.should == "126330996"
        tudou_l2_swf.id.should == "126330996"
        tudou_dp_l.id.should == "126315712"
        tudou_dp_l2.id.should == "126330996"
      end
    end

    describe "#html_url" do
      it "should return id" do
        tudou_l_swf.html_url.should == "http://www.tudou.com/listplay/ofVJWe0u0sI/zsbv-3JbxJk.html"
        tudou_l2_swf.html_url.should == "http://www.tudou.com/listplay/ofVJWe0u0sI/_4805-g0kM8.html"
      end
    end

    describe "#flash" do
      it "should return flash" do
        tudou_l.flash.should == "http://www.tudou.com/l/ofVJWe0u0sI/&rpid=116105338&resourceId=116105338_04_05_99&iid=126315712/v.swf"
        tudou_l2.flash.should == "http://www.tudou.com/l/ofVJWe0u0sI/&rpid=116105338&resourceId=116105338_04_05_99&iid=126330996/v.swf"
      end
    end
   
  end

  context "when url type is oplay" do
    let(:tudou_o){Getvideo::Tudou.new "http://www.tudou.com/oplay/zfHEUbMXwr0.html"}
    let(:tudou_o_swf){Getvideo::Tudou.new "http://www.tudou.com/o/zfHEUbMXwr0/&rpid=116105338&resourceId=116105338_04_0_99&iid=143085669/v.swf"}
    let(:tudou_o2){Getvideo::Tudou.new "http://www.tudou.com/oplay/zfHEUbMXwr0/n4ZwfsvJ2Wk.html"}
    let(:tudou_o2_swf){Getvideo::Tudou.new "http://www.tudou.com/o/zfHEUbMXwr0/&rpid=116105338&resourceId=116105338_04_0_99&iid=143085669/v.swf"}
    let(:tudou_dp_o){Getvideo::Tudou.new "http://dp.tudou.com/o/zfHEUbMXwr0.html"}
    let(:tudou_dp_o2){Getvideo::Tudou.new "http://dp.tudou.com/o/zfHEUbMXwr0/n4ZwfsvJ2Wk.html"}

    describe "#id" do
      it "should return id" do
        tudou_o.id.should == "143085669"
        tudou_o_swf.id.should == "143085669"
        tudou_o2.id.should == "143085669"
        tudou_o2_swf.id.should == "143085669"
        tudou_dp_o.id.should == "143085669"
        tudou_dp_o2.id.should == "143085669"
      end
    end


  end
end
