#coding:utf-8
require 'spec_helper'

describe Getvideo::Sina do
  let(:iask){ Getvideo::Sina.new "http://video.sina.com.cn/v/b/87948161-2162799562.html" }
  let(:iask_swf){ Getvideo::Sina.new "http://you.video.sina.com.cn/api/sinawebApi/outplayrefer.php/vid=87948161_2162799562_PE+1GCBtBjbK+l1lHz2stqkP7KQNt6nniGy2vFutIAhbQ0/XM5GRZdQD6CjQAdkEqDhATJ82cfYn0Rw/s.swf" }
  let(:iask_id){ Getvideo::Sina.new "87948161|2162799562" }
  let(:iask_noflash){ Getvideo::Sina.new "http://video.sina.com.cn/m/xbfmnz_61889719.html" }
  

  describe "#id" do
    it "should return true id" do
      iask.id.should == "87948161"
      iask_swf.id.should == "87948161"
      iask_id.id.should == "87948161"
    end
  end

  describe "#html_url" do
    it "should return html url" do
      iask_swf.html_url.should == "http://video.sina.com.cn/v/b/87948161-2162799562.html"
      iask_id.html_url.should == "http://video.sina.com.cn/v/b/87948161-2162799562.html"
    end
  end

  describe "#flash" do
    it "should return flash url" do
      iask.flash.should match(/s.swf/)
      iask_noflash.flash.should be_empty()
    end
  end

  describe "#title" do
    it "should return title text" do
     iask.title.should match(/1080p/)
    end
  end

  describe "#cover" do
    it "should return cover url" do
     iask.cover.should match(/\.jpg/)
    end
  end

  describe "#media" do
    it "should return media data" do
      iask.media["hlv"][0].should match(/edge\.v\.iask.com.+\.hlv/) 
      iask_swf.media["hlv"][0].should match(/edge\.v\.iask.com.+\.hlv/) 
      iask_id.media["hlv"][0].should match(/edge\.v\.iask.com.+\.hlv/) 
    end
  end

  context "when url is play_list" do
    let(:iask_p){ Getvideo::Sina.new "http://video.sina.com.cn/playlist/5204279-2214257545-1.html#68348849" }
    let(:iask_p2){ Getvideo::Sina.new "http://video.sina.com.cn/playlist/4077594-1549077107-2.html" }
    let(:iask_p_swf){ Getvideo::Sina.new "http://you.video.sina.com.cn/api/sinawebApi/outplayrefer.php/vid=68348849_2214257545_aR69SnA+C2DK+l1lHz2stqkP7KQNt6nni2uwuVejIApcQ0/XM5Gfat4D6CHSCdkEqDhAQpA8cfYu0xQ/s.swf" }

    describe "#id" do
      it "should return true id" do
        iask_p.id.should == "68348849"
        iask_p2.id.should match(/[\d]+/)
        iask_p_swf.id.should == "68348849"
      end
    end

    describe "#html_url" do
      it "should return html url" do
        iask_p_swf.html_url.should == "http://video.sina.com.cn/v/b/68348849-2214257545.html"
      end
    end

    describe "#media" do
    it "should return media data" do
      iask_p.media["hlv"][0].should match(/\.hlv/) 
      iask_p_swf.media["hlv"][0].should match(/\.hlv/) 
    end
  end


  end


  context "when url is news" do
    let(:iask_n){ Getvideo::Sina.new "http://video.sina.com.cn/p/news/c/v/2012-10-21/101961889769.html" }
    #let(:iask_n){ Getvideo::Iask.new "http://news.sina.com.cn/z/video/rbgd2012/#88208237_6" }
    let(:iask_n_id){ Getvideo::Sina.new "http://video.sina.com.cn/p/news/c/v/2012-10-21/101961889769.html#61889105" }
    let(:sina){Getvideo::Sina.new "http://video.sina.com.cn/p/ent/m/m/2014-03-25/183663661343.html"}
    let(:iask_n_swf){ Getvideo::Sina.new "http://you.video.sina.com.cn/api/sinawebApi/outplayrefer.php/vid=88279853_1_bEO9GyM9DWfK+l1lHz2stqkM7KQNt6nknynt71+iJAZRXAuIborfO4kK6CHUB8ZK9G8/s.swf" }

    describe "#id" do
      it "should return true id" do
        iask_n.id.should == "88279853"
        iask_n_id.id.should == "61889105"
        iask_n_swf.id.should == "88279853"
        sina.id.should == "129348331"
      end
    end

    describe "#html_url" do
      it "should return html url" do
        iask_n_swf.html_url.should be_empty 
        sina.html_url.should == "http://video.sina.com.cn/p/ent/m/m/2014-03-25/183663661343.html"
      end
    end
    
    describe "#media" do
    it "should return media data" do
      #iask_n.media["hlv"].count.should eq(1) 
      #iask_n_swf.media["hlv"].count.should eq(1) 
      pp sina.m3u8
    end
  end

  describe "#cover" do
    it "should return cover url" do
     iask_n_swf.cover.should be_empty
    end
  end
  
  describe "#title" do
    it "should return title" do
     iask_n_swf.title.should match(/美航母/)
    end
  end

  describe "#m3u8" do
    it "should return m3u8" do 
      iask_n_swf.m3u8.should be_empty
    end
    end
  end
end
