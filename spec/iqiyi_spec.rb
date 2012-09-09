require 'spec_helper'

describe Getvideo::Iqiyi do
  let(:iqiyi){ Getvideo::Iqiyi.new("http://www.iqiyi.com/dianying/20100920/n39712.html")}
  describe "#id" do
    it{ iqiyi.id.should == "15f0e3f6fe8511dfaa6aa4badb2c35a1" }
  end

  describe "#m3u8" do
    it{ iqiyi.m3u8 }
  end

  describe "#flash" do
    it{ iqiyi.flash }
  end

  describe "#flv" do
    it{ iqiyi.flv }
  end
end
