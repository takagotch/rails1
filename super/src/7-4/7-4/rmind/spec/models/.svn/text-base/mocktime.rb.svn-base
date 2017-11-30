require File.dirname(__FILE__) + '/../spec_helper'

describe "mocktime" do
  it "is like original Time without setting up" do
    Time.now.should be_kind_of(Time)
  end

  it "can set mock time" do
    Time.with_mock_time("1/2 3:4:5") do
      Time.now.should == Time.local(Time.now.year, 1, 2, 3, 4, 5)
    end
  end

  it "can nest mock time" do
    Time.with_mock_time("1/2 3:4:5") do
      Time.now.should == Time.local(Time.now.year, 1, 2, 3, 4, 5)
      Time.with_mock_time("5/4 3:2:1") do
        Time.now.should == Time.local(Time.now.year, 5,4,3,2,1)
      end
      Time.now.should == Time.local(Time.now.year, 1, 2, 3, 4, 5)
    end
  end

  it "can advance mock time" do
    Time.with_mock_time("1/2 3:4:5") do
      Time.now.should == Time.local(Time.now.year, 1, 2, 3, 4, 5)
      Time.advance(1)
      Time.now.should == Time.local(Time.now.year, 1, 2, 3, 4, 6)
      Time.advance(1.minute)
      Time.now.should == Time.local(Time.now.year, 1, 2, 3, 5, 6)
      Time.advance(1.hour)
      Time.now.should == Time.local(Time.now.year, 1, 2, 4, 5, 6)
      Time.advance(1.day)
      Time.now.should == Time.local(Time.now.year, 1, 3, 4, 5, 6)
      Time.advance(1.month)
      Time.now.should == Time.local(Time.now.year, 2, 2, 4, 5, 6)
    end
  end
end
