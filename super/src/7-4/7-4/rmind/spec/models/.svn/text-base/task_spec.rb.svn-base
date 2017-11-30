require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Task do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    @task = Task.new :user=>@user, :text=>'aaa'
    @task.save
  end

  it "should be valid" do
    @task.should be_valid
    @task.text.should == "aaa"
    @task.user.should_not be_nil
    @task.user.should == @user
    @task.user.login.should == "u1"
  end

  it "should not be valid without text" do
    task = Task.new :user=>@user, :text=>''
    task.should_not be_valid
    task.text = "aaa"
    @task.should be_valid
    task.text.should == "aaa"
    task.user.should_not be_nil
    task.user.should == @user
    task.user.login.should == "u1"
  end

  it "can be accessed with scope" do
    @user.with_myscope do
      Task.create :text=>'new task'
      new_task = Task.find_by_text('new task')
      new_task.should_not be_nil
      new_task.user.should == @user

      t = Task.find_by_text('aaa')
      t.should == @task
    end
  end

  it "can be accessed with scope" do
    @user.with_myscope do
      Task.create :text=>'new task'
      new_task = Task.find_by_text('new task')
      new_task.should_not be_nil
      new_task.user.should == @user

      t = Task.find_by_text('aaa')
      t.should == @task
    end
  end

  it "cannot be accessed by other user" do
    new_user = User.create(:login=>'new_user', :email=>'dummy')
    new_user.initial_setup
    new_user.save!

    new_user.with_myscope do
      Task.create :text=>'new task'
      new_task = Task.find_by_text('new task')
      new_task.should_not be_nil
      new_task.user.should == new_user

      t = Task.find_by_text('aaa')
      t.should be_nil
    end

    @user.with_myscope do
      new_task = Task.find_by_text('new task')
      new_task.should be_nil
    end
  end

  it "can be done" do
    @user.with_myscope do
      Time.with_mock_time("2007 1/2") do
        t = Task.create :text=>'task 1'
        t.should_not be_done
        t.record_done
        t.should be_done
        t.done_at.should == Time.parse("2007 1/2")
      end
    end
  end

  it "can be trashed" do
    @user.with_myscope do
      Time.with_mock_time("2007 1/2") do
        t = Task.create :text=>'task 1'
        t.should_not be_trashed
        t.trash
        t.should be_trashed
        t.trashed_at.should == Time.parse("2007 1/2")
        t.trashed_at = nil
        t.should_not be_trashed
      end
    end
  end

  it "can be tagged" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "aaa"
      t.save!

      tag = Tag.find_by_name("aaa")
      tag.should have(1).taggings
      tag.taggings.first.task.should == t
      t.taggings.first.tag.should == tag
      t.tag.should == "aaa"
    end
  end

  it "can be tagged with many tags" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "aaa bbb ccc"
      t.save!
      t.should have(3).taggings
      t.tag.should == "aaa bbb ccc"
    end
  end

  it "can be tagged with many tags and change them" do
    @user.with_myscope do
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "aaa bbb ccc"
      t.save!
      t.tag.should == "aaa bbb ccc"
      t.tag = "aaa"
      t.save!
      t.tag.should == "aaa"
      t.tag = "xxx yyy"
      t.save!
      t.tag.should == "xxx yyy"
    end
  end

  it "can be tagged with context tags" do
    @user.with_myscope do
      create_context_tags("@home", "@office")
      t = Task.create :text=>'task 1'
      t.should have(0).taggings
      t.tag = "@home abc"
      t.save!
      t.tag.should == "@home abc"
    end
  end

  def create_context_tags(*args)
    args.each do |n|
      ContextTag.create(:user=>@user, :name=>n)
    end
  end
end

describe Task, "status" do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    @task = Task.new :user=>@user, :text=>'aaa'
    @task.save
    @prj = @user.root_project.sub_projects.create(:name => 'prj')
  end

  it "is Inbox after creation" do
    @task.status.should == Task::Status::Inbox
  end

  it "is Processed after processed" do
    @task.project = @prj
    @task.save!
    @task.status.should == Task::Status::Processed
  end

  it "is NextAction with ContextTag" do
    @task.tag = '@office'
    @task.save!
    @task.status.should == Task::Status::NextAction
  end

  it "is Waiting with DelegationTag or ScheduleTag" do
    @task.tag = 'id:xxx'
    @task.save!
    @task.status.should == Task::Status::Waiting
    @task.tag = '20070101'
    @task.save!
    @task.status.should == Task::Status::Waiting
  end

  it "is Done after done" do
    @task.record_done
    @task.save!
    @task.status.should == Task::Status::Done
  end

  it "is Trashed after trashed" do
    @task.trash
    @task.save!
    @task.status.should == Task::Status::Trashed
  end
end
