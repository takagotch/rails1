require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Address do
  it_should_behave_like "TestWithOneUser"
  it "will be created with DelegationTag" do
    @user.with_myscope do
      task = Task.create :text=>'task with memo'
      task.tag="id:essa"
      task.save!
      task.tag.should == "id:essa"
      tag = task.tags.first
      tag.should be_kind_of(DelegationTag)

      tag.address.should be_nil
      tag.create_address(:email=>"tnaka@dc4.so-net.ne.jp", :mixi=>1345, :twitter=>"essa")

      dtag = @user.tags.find(:first, :conditions=>['name = ?', "id:essa"])
      addr = dtag.address
      addr.email.should == "tnaka@dc4.so-net.ne.jp"
      addr.mixi.should == "1345"
      addr.twitter.should == "essa"

    end
  end
end
