require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Tagging do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
  end

  it "should be created and bind to user and task" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.tag = "aaa bbb"
      t.save
      t.tag.should == "aaa bbb"
      t.should have(2).taggings
      @user.should have(2).taggings
      t.destroy
    end
    @user.reload
    @user.should have(0).tasks
    @user.should have(0).taggings
    Tagging.find(:all).size.should == 0
    Task.find(:all).size.should == 0
  end
end
