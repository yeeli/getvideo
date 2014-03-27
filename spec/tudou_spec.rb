require 'spec_helper'

describe Getvideo::Tudou do
  context "when url type with program" do
    #### 
    # tudou program vedio
    # iid = 188982955
    # lcode = rCg0cXZ2_6g
    ####
    let(:tudou_v){ Getvideo::Tudou.new "http://www.tudou.com/programs/view/rCg0cXZ2_6g/" }
    let(:tudou_v_swf){ Getvideo::Tudou.new "http://www.tudou.com/v/rCg0cXZ2_6g/&rpid=119749846&resourceId=119749846_04_05_99/v.swf" }

    describe "#id" do
      it "should equal 188982955" do
        tudou_v.id.should == "188982955"
        tudou_v_swf.id.should == "188982955"
      end
    end

    describe "#html_url" do
      it "should equal http://www.tudou.com/programs/view/rCg0cXZ2_6g/" do
        tudou_v.html_url.should eq("http://www.tudou.com/programs/view/rCg0cXZ2_6g/")
        tudou_v_swf.html_url.should eq("http://www.tudou.com/programs/view/rCg0cXZ2_6g/")
      end
    end

    describe "#flash" do
      it "should equal http://www.tudou.com/v/rCg0cXZ2_6g/v.swf" do
        tudou_v.flash.should eq("http://www.tudou.com/v/rCg0cXZ2_6g/v.swf")
        tudou_v_swf.flash.should eq("http://www.tudou.com/v/rCg0cXZ2_6g/v.swf")
      end
    end

    describe "#title" do
      it "should get video name equal 【伦敦之心】坛久保 - 女性向摔跤揭秘" do
        tudou_v.title.should eq("【伦敦之心】坛久保 - 女性向摔跤揭秘")
        tudou_v_swf.title.should eq("【伦敦之心】坛久保 - 女性向摔跤揭秘")
      end
    end

    describe "#cover" do
      it "should equal " do
        tudou_v.cover.should eq("http://i2.tdimg.com/188/982/955/p.jpg")
        tudou_v_swf.cover.should eq("http://i2.tdimg.com/188/982/955/p.jpg")
      end
    end

    describe "#m3u8" do
      it "should equal http://vr.tudou.com/v2proxy/v2.m3u8?it=188982955&st=2&pw=" do
        tudou_v.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=188982955&st=2&pw=")
        tudou_v_swf.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=188982955&st=2&pw=")
      end
    end

  end

  context "when url type with lisplay" do
    ####
    #  tudou list video
    #  lcode = 'BCbkQV3rOFc' 
    #  lid = 17491087
    #  iid = 189900273
    #  icode = WK3rjXAAbd4
    ####
    let(:tudou_list1){ Getvideo::Tudou.new "http://www.tudou.com/listplay/BCbkQV3rOFc/WK3rjXAAbd4.html" }
    let(:tudou_list2){ Getvideo::Tudou.new "http://www.tudou.com/listplay/BCbkQV3rOFc.html" }
    let(:tudou_list_swf){ Getvideo::Tudou.new "http://www.tudou.com/l/BCbkQV3rOFc/&iid=189900273&rpid=119749846&resourceId=119749846_04_05_99/v.swf" }
   
    describe "#id" do
      it "should equal 189900273" do
        tudou_list1.id.should == "189900273"
        tudou_list2.id.should == "189900273"
        tudou_list_swf.id.should == "189900273"
      end
    end

    describe "#html_url" do
      it "should equal http://www.tudou.com/listplay/BCbkQV3rOFc/WK3rjXAAbd4.html" do
        tudou_list1.html_url.should eq("http://www.tudou.com/listplay/BCbkQV3rOFc/WK3rjXAAbd4.html")
        tudou_list2.html_url.should eq("http://www.tudou.com/listplay/BCbkQV3rOFc/WK3rjXAAbd4.html")
        tudou_list_swf.html_url.should eq("http://www.tudou.com/listplay/BCbkQV3rOFc/WK3rjXAAbd4.html")
      end
    end

    describe "#flash" do
      it "should" do
        tudou_list1.flash.should eq("http://www.tudou.com/l/BCbkQV3rOFc/&iid=189900273/v.swf")
        tudou_list2.flash.should eq("http://www.tudou.com/l/BCbkQV3rOFc/&iid=189900273/v.swf")
        tudou_list_swf.flash.should eq("http://www.tudou.com/l/BCbkQV3rOFc/&iid=189900273/v.swf")
      end
    end

    describe "#media" do
      it "should" do
        tudou_list1.media.count.should eq(5)
        tudou_list2.media.count.should eq(5)
        tudou_list_swf.media.count.should eq(5)
      end
    end

    describe "#cover" do
      it "should" do
        tudou_list1.cover.should eq("http://g2.tdimg.com/e3c1e6a10fe815112a7076609dae5c26/w_2.jpg")
        tudou_list2.cover.should eq("http://g2.tdimg.com/e3c1e6a10fe815112a7076609dae5c26/w_2.jpg")
        tudou_list_swf.cover.should eq("http://g2.tdimg.com/e3c1e6a10fe815112a7076609dae5c26/w_2.jpg")
      end
    end

    describe "#m3u8" do
      it "should" do
        tudou_list1.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=189900273&st=2&pw=")
        tudou_list2.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=189900273&st=2&pw=")
        tudou_list_swf.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=189900273&st=2&pw=")
      end
    end

    describe "#title" do
      it "should" do
        tudou_list1.title.should eq("给你个机会做男人 你愿意吗？妹子神回复【神街访】")
        tudou_list2.title.should eq("给你个机会做男人 你愿意吗？妹子神回复【神街访】")
        tudou_list_swf.title.should eq("给你个机会做男人 你愿意吗？妹子神回复【神街访】")
      end
    end
  end

  context "when url type with albumplay" do
    ####
    #  tudou albumplay video 1
    #  lid = 235139
    #  lcode = lwRXz9WFd48
    #  ylid = 286629
    #  iid = 131675891
    #  icode = Tb6_eGHHjAI
    #  vcode = XNjY2NTMyNDgw
    #
    #  tudou albumplay video 2
    #  lid = 235139
    #  lcode = lwRXz9WFd48
    #  ylid = 286629
    #  iid = 131675896
    #  icode = Tb6_eGHHjAI
    #  vcode =  XNjY2NTMyNDgw
    ###
    let(:tudou_albumplay1){ Getvideo::Tudou.new "http://www.tudou.com/albumplay/lwRXz9WFd48/uW1V7DwwNNY.html"}
    let(:tudou_albumplay2){ Getvideo::Tudou.new "http://www.tudou.com/albumplay/lwRXz9WFd48.html"}
    let(:tudou_albumplay3){ Getvideo::Tudou.new "http://www.tudou.com/albumplay/lwRXz9WFd48/Tb6_eGHHjAI.html"}
    let(:tudou_albumplay_swf1){ Getvideo::Tudou.new "http://www.tudou.com/a/lwRXz9WFd48/&iid=131675891&rpid=119749846&resourceId=119749846_04_05_99/v.swf" }
    let(:tudou_albumplay_swf2){ Getvideo::Tudou.new "http://www.tudou.com/a/lwRXz9WFd48/&iid=131675896&rpid=119749846&resourceId=119749846_04_05_99/v.swf" }

    describe "#id" do
      it "should equal 131675896" do
        tudou_albumplay1.id.should eq("131675891")
        tudou_albumplay2.id.should eq("131675891")
        tudou_albumplay3.id.should eq("131675896")
        tudou_albumplay_swf1.id.should eq("131675891")
        tudou_albumplay_swf2.id.should eq("131675896")
      end
    end

    describe "#html_url" do
      it "should equal http://www.tudou.com/albumplay/lwRXz9WFd48/uW1V7DwwNNY.html" do
        tudou_albumplay1.html_url.should eq("http://www.tudou.com/albumplay/lwRXz9WFd48/uW1V7DwwNNY.html")
        tudou_albumplay2.html_url.should eq("http://www.tudou.com/albumplay/lwRXz9WFd48/uW1V7DwwNNY.html")
        tudou_albumplay3.html_url.should eq("http://www.tudou.com/albumplay/lwRXz9WFd48/Tb6_eGHHjAI.html")
        tudou_albumplay_swf1.html_url.should eq("http://www.tudou.com/albumplay/lwRXz9WFd48/uW1V7DwwNNY.html")
        tudou_albumplay_swf2.html_url.should eq("http://www.tudou.com/albumplay/lwRXz9WFd48/Tb6_eGHHjAI.html")
      end
    end

    describe "flash" do
      it "should return real flash" do
        tudou_albumplay1.flash.should eq("http://www.tudou.com/a/lwRXz9WFd48/&iid=131675891/v.swf")
        tudou_albumplay2.flash.should eq("http://www.tudou.com/a/lwRXz9WFd48/&iid=131675891/v.swf")
        tudou_albumplay3.flash.should eq("http://www.tudou.com/a/lwRXz9WFd48/&iid=131675896/v.swf")
        tudou_albumplay_swf1.flash.should eq("http://www.tudou.com/a/lwRXz9WFd48/&iid=131675891/v.swf")
        tudou_albumplay_swf2.flash.should eq("http://www.tudou.com/a/lwRXz9WFd48/&iid=131675896/v.swf")
      end
    end

    describe "#media" do
      it "should get 3 media" do
        tudou_albumplay1.media.count.should eq(3)
        tudou_albumplay2.media.count.should eq(3)
        tudou_albumplay3.media.count.should eq(3)
        tudou_albumplay_swf1.media.count.should eq(3)
        tudou_albumplay_swf2.media.count.should eq(3)
      end
    end

    describe "#cover" do
      it "should get real cover" do
        tudou_albumplay1.cover.should eq("http://g3.ykimg.com/11270F1F4652E4F6DE2030000000002C541A48-C9BA-60F1-557B-4F5D58E7820B")
        tudou_albumplay2.cover.should eq("http://g3.ykimg.com/11270F1F4652E4F6DE2030000000002C541A48-C9BA-60F1-557B-4F5D58E7820B")
        tudou_albumplay3.cover.should eq("http://g2.ykimg.com/11270F1F4652E4FF55A147000000004D785935-2C2C-DB1C-7C9E-ECBE99D259D5")
        tudou_albumplay_swf1.cover.should eq("http://g3.ykimg.com/11270F1F4652E4F6DE2030000000002C541A48-C9BA-60F1-557B-4F5D58E7820B")
        tudou_albumplay_swf2.cover.should eq("http://g2.ykimg.com/11270F1F4652E4FF55A147000000004D785935-2C2C-DB1C-7C9E-ECBE99D259D5")
      end
    end

    describe "#title" do
      it "should get video name equal 发胶喷太猛一秒就爆炸" do
        tudou_albumplay1.title.should eq("发胶喷太猛一秒就爆炸")
        tudou_albumplay2.title.should eq("发胶喷太猛一秒就爆炸")
        tudou_albumplay3.title.should eq("缺德男电梯调戏仨美女")
        tudou_albumplay_swf1.title.should eq("lol:-) 第二季 01")
        tudou_albumplay_swf2.title.should eq("lol:-) 第二季 11")
      end
    end

    describe "#cover" do
      it "should get real cover" do
        tudou_albumplay1.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=131675891&st=2&pw=")
        tudou_albumplay2.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=131675891&st=2&pw=")
        tudou_albumplay3.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=131675896&st=2&pw=")
        tudou_albumplay_swf1.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=131675891&st=2&pw=")
        tudou_albumplay_swf2.m3u8.should eq("http://vr.tudou.com/v2proxy/v2.m3u8?it=131675896&st=2&pw=")
      end
    end
  end

  context "when url type with oplay" do
    ####
    #  tudou oplay video
    #  lid = 98167
    #  lcode = 6jo2_Ep6Jbg
    #  ylid = 22642
    #  iid = 130441856
    #  icode = pJKf69qZMyQ
    #  vcode = XMzU1NDE5MTYw
    ###
    let(:tudou_oplay){ Getvideo::Tudou.new "www.tudou.com/oplay/6jo2_Ep6Jbg/pJKf69qZMyQ.html"}
    let(:tudou_oplay_swf){ Getvideo::Tudou.new "http://www.tudou.com/o/6jo2_Ep6Jbg/&iid=130441856&rpid=119749846&resourceId=119749846_04_05_99/v.swf"}

    describe "#id" do
      it "should equal 130441856" do
        tudou_oplay.id.should eq("130441856")
        tudou_oplay_swf.id.should eq("130441856")
      end
    end

    describe "title" do
      it "should equal 十一罗汉-Ocean's Eleven(2001)中文预告片" do
        tudou_oplay.title.should eq("十一罗汉-Ocean's Eleven(2001)中文预告片")
        tudou_oplay_swf.title.should eq("十一罗汉-Ocean's Eleven(2001)中文预告片")
      end
    end

    describe "#html_url" do
      it "should equal http://www.tudou.com/albumplay/6jo2_Ep6Jbg/pJKf69qZMyQ.html" do
        tudou_oplay.html_url.should eq("http://www.tudou.com/albumplay/6jo2_Ep6Jbg/pJKf69qZMyQ.html")
        tudou_oplay_swf.html_url.should eq("http://www.tudou.com/albumplay/6jo2_Ep6Jbg/pJKf69qZMyQ.html")
      end
    end

    describe "flash" do
      it "should equal http://www.tudou.com/o/6jo2_Ep6Jbg/&iid=130441856/v.swf" do
        tudou_oplay.flash.should eq("http://www.tudou.com/a/6jo2_Ep6Jbg/&iid=130441856/v.swf")
        tudou_oplay_swf.flash.should eq("http://www.tudou.com/a/6jo2_Ep6Jbg/&iid=130441856/v.swf")
      end
    end

    describe "cover" do
      it "should get real cover" do
        tudou_oplay.cover.should eq("http://g3.ykimg.com/1100641F46510C41BA2F3300B49D4A19E2DAE9-14BD-BAC8-1EF3-05BCB948C329")
        tudou_oplay_swf.cover.should eq("http://g3.ykimg.com/1100641F46510C41BA2F3300B49D4A19E2DAE9-14BD-BAC8-1EF3-05BCB948C329")
      end
    end
  end
end
