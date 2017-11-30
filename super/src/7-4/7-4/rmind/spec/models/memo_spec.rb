require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Memo do
  it_should_behave_like "TestWithOneUser"

  it "will be created with MemoTag" do
    @user.with_myscope do
      memotag = MemoTag.create(:user=>@user, :name => 'memo')
      task = Task.create :text=>'task with memo'
      task.tagging_value['memo'][:memo] = 'memo abc'
      task.tag="memo"
      task.save!

      memo = Memo.find(:first)
      memo.memo.should == 'memo abc'

      t = Task.find(task.id)
      t.text.should == 'task with memo'
      t.load_tagging_value
      t.tagging_value['memo'][:memo].should == "memo abc"
    end
  end

  it "will not be deleted at changing tags" do
    @user.with_myscope do
      memotag = MemoTag.create(:user=>@user, :name => 'memo')
      task = Task.create :text=>'task with memo'
      task.tagging_value['memo'][:memo] = 'memo abc'
      task.tag="memo"
      task.save!
      task.tag="memo abc"
      task.save!

      t = Task.find(task.id)
      t.tag.should == "abc memo"
      t.text.should == 'task with memo'
      t.load_tagging_value
      t.tagging_value['memo'][:memo].should == "memo abc"
      t.tag="memo abc xyz"
      task.save!
      t.tag.should == "memo abc xyz"
      task.reload
      t.tag.should == "memo abc xyz"
      t.tagging_value['memo'][:memo].should == "memo abc"
    end
  end
end

