require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Tag do
  it_should_behave_like "TestWithOneUser"
  it "should be separated by space" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "aaa bbb"
      t.save!

      Tag.find_by_name("aaa").should_not be_nil
      Tag.find_by_name("bbb").should_not be_nil

      t.reload
      t.tag.should == "aaa bbb"
    end
  end

  it "should be separated by unicode space" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "aaa　bbb"
      t.save!

      Tag.find_by_name("aaa").should_not be_nil
      Tag.find_by_name("bbb").should_not be_nil

      t.reload
      t.tag.should == "aaa bbb"

      t.tag = "あああ　いいい　aaa"
      t.save!

      Tag.find_by_name("aaa").should_not be_nil
      Tag.find_by_name("あああ").should_not be_nil
      Tag.find_by_name("いいい").should_not be_nil

      t.reload
      t.tag.should == "aaa あああ いいい"
    end
  end
end

describe Tag, "DelegationTag" do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    @task = Task.create :user=>@user, :text=>'aaa'
    @task.save
  end

  it "will be created automaticaly with 'id:xxx'" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "id:aaa"
      t.save!

      tag = Tag.find_by_name("id:aaa")
      tag.should be_kind_of(DelegationTag)
      tag.should have(1).taggings
      tag.taggings.first.task.should == t
      t.taggings.first.tag.should == tag
      t.tag.should == "id:aaa"
    end
  end
end

