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
      it{ tudou_v.cover.should match(/tdimg|ykimg/) }
    end

    describe "#m3u8" do
      it{ tudou_v.m3u8.should == "http://vr.tudou.com/v2proxy/v2.m3u8?it=151831829&st=2&pw="  }
    end

    describe "#media" do
      it{ tudou_v.media["f4v"].count.should be(2)}
    end
  end

  context "when url type is albumplay" do
    let(:tudou_a){Getvideo::Tudou.new "http://www.tudou.com/albumplay/MgWfoV9cT4E.html"}
    #会跳转url
    let(:tudou_a1){Getvideo::Tudou.new "http://www.tudou.com/albumplay/1D9nGd3U0ks/WjNmtxWnbac.html"}
    let(:tudou_a_swf){Getvideo::Tudou.new "http://www.tudou.com/a/MgWfoV9cT4E/&resourceId=0_04_05_99&iid=131561214/v.swf"}
    let(:tudou_a2){Getvideo::Tudou.new "http://www.tudou.com/albumplay/oYvFcu7I5YY/RO-yBcJdGws.html"}
    let(:tudou_a2_swf){Getvideo::Tudou.new "http://www.tudou.com/a/oYvFcu7I5YY/&resourceId=0_04_05_99&iid=131561156/v.swf"}
    let(:tudou_dp_a){Getvideo::Tudou.new "http://dp.tudou.com/a/MgWfoV9cT4E.html"}
    let(:tudou_dp_a2){Getvideo::Tudou.new "http://dp.tudou.com/a/MgWfoV9cT4E/A49rc-hkUrY.html"}

    describe "#id" do
      it "should return id" do
        tudou_a_swf.id.should == "131561214"
        tudou_a2.id.should == "131561156"
        tudou_a2_swf.id.should == "131561156"
        tudou_dp_a.id.should == "131532821"
        tudou_dp_a2.id.should == "131561214"
      end
    end

    describe "#html_url" do
      it "should return id" do
        tudou_a_swf.html_url.should == "http://www.tudou.com/albumplay/MgWfoV9cT4E.html"
        tudou_a2_swf.html_url.should == "http://www.tudou.com/albumplay/oYvFcu7I5YY.html"
        tudou_dp_a.html_url.should == "http://www.tudou.com/albumplay/MgWfoV9cT4E.html"
        tudou_dp_a2.html_url.should == "http://www.tudou.com/albumplay/MgWfoV9cT4E/A49rc-hkUrY.html"
      end
    end

    describe "#flash" do
      it "should return flash" do
        tudou_a.flash.should == "http://www.tudou.com/a/MgWfoV9cT4E/&rpid=116105338&resourceId=116105338_04_05_99&iid=131532821/v.swf"
        tudou_a2.flash.should == "http://www.tudou.com/a/oYvFcu7I5YY/&rpid=116105338&resourceId=116105338_04_05_99&iid=131561156/v.swf"
        tudou_dp_a.flash.should == "http://www.tudou.com/a/MgWfoV9cT4E/&rpid=116105338&resourceId=116105338_04_05_99&iid=131532821/v.swf"
        tudou_dp_a2.flash.should == "http://www.tudou.com/a/MgWfoV9cT4E/&rpid=116105338&resourceId=116105338_04_05_99&iid=131561214/v.swf"
      end
    end
    
    describe "#cover" do
      it "should return cover" do 
        tudou_a.cover.should match(/tdimg|ykimg/) 
        tudou_a1.cover.should match(/tdimg|ykimg/) 
      end
    end

    describe "#media" do
      it "return media url" do
        tudou_a.media["f4v"].count.should be(0)
        tudou_a.media["flv"].count.should be(0)
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
        tudou_l.id.should == "161629341"
        tudou_l_swf.id.should == "126315712"
        tudou_l2.id.should == "126330996"
        tudou_l2_swf.id.should == "126330996"
        tudou_dp_l.id.should == "161629341"
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
        tudou_l.flash.should == "http://www.tudou.com/l/ofVJWe0u0sI/&rpid=116105338&resourceId=116105338_04_05_99&iid=161629341/v.swf"
        tudou_l2.flash.should == "http://www.tudou.com/l/ofVJWe0u0sI/&rpid=116105338&resourceId=116105338_04_05_99&iid=126330996/v.swf"
      end
    end
   
  end

  context "when url type is oplay" do
    let(:tudou_o){Getvideo::Tudou.new "http://www.tudou.com/oplay/6jo2_Ep6Jbg.html"}
    let(:tudou_o_swf){Getvideo::Tudou.new "http://www.tudou.com/o/6jo2_Ep6Jbg/&resourceId=0_04_05_99&iid=130441856/v.swf"}
    let(:tudou_o2){Getvideo::Tudou.new "http://www.tudou.com/oplay/6jo2_Ep6Jbg/pJKf69qZMyQ.html"}
    let(:tudou_o2_swf){Getvideo::Tudou.new "http://www.tudou.com/o/6jo2_Ep6Jbg/&resourceId=0_04_05_99&iid=130441856/v.swf"}

    describe "#id" do
      it "should return id" do
        tudou_o.id.should == "131649672"
        tudou_o_swf.id.should == "130441856"
        tudou_o2.id.should == "130441856"
        tudou_o2_swf.id.should == "130441856"
      end
    end
  end
end
