require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe Schedule do
  it_should_behave_like "TestWithOneUser"

  it "will be created with DateTag" do
    @user.with_myscope do
      task = Task.create :text=>'task with schedule'
      task.tagging_value["070102"][:from] = Time.parse("07 1/2 3:30")
      task.tag = "070102"
      task.save!
    end


    sch = Schedule.find(:first)
    sch.should_not be_nil
    sch.date.should == Date.new(2007, 1, 2)
    sch.from.should == Time.parse("2007 1/2 3:30")

    @user.with_myscope do
      tag = @user.find_tag("070102")
      tag.should be_kind_of(ScheduleTag)
      task = tag.tasks.first

      task.should == Task.find_by_text('task with schedule')
      task.tag.should == "070102"
      task.load_tagging_value
      task.tagging_value["070102"][:from].should == Time.parse("2007 1/2 3:30")
    end
  end

  it "will be updated with DateTag" do
    @user.with_myscope do
      task = Task.create :text=>'task with schedule'
      task.tagging_value["070102"][:from] = Time.parse("2007 1/2 3:30")
      task.tag = "070102"
      task.save!
    end

    @user.with_myscope do
      task = Task.find_by_text 'task with schedule'
      task.load_tagging_value
      task.tagging_value["070102"][:from] = Time.parse("2007 4/5 6:7")
      task.tag = "070102"
      task.save!
    end

    sch = Schedule.find(:first)
    sch.should_not be_nil
    sch.date.should == Date.new(2007, 1, 2)
    sch.from.should == Time.parse("2007 4/5 6:7")

    @user.with_myscope do
      task = Task.find_by_text('task with schedule')
      task.tag.should == "070102"
      task.load_tagging_value
      task.tagging_value["070102"][:from].should == Time.parse("2007 4/5 6:7")
    end
  end

  it "will be created with each DateTag" do
    @user.with_myscope do
      task = Task.create :text=>'task with schedule'
      task.tagging_value["070102"][:from] = Time.parse("2007 1/2 3:30")
      task.tagging_value["070103"][:from] = Time.parse("2007 1/3 12:34")
      task.tag = "070102 070103"
      task.save!
    end


    sch = Schedule.find(:first)
    sch.should_not be_nil
    sch.date.should == Date.new(2007, 1, 2)
    sch.from.should == Time.parse("2007 1/2 3:30")

    @user.with_myscope do
      tag = @user.find_tag("070102")
      tag.should be_kind_of(ScheduleTag)
      task = tag.tasks.first

      task.should == Task.find_by_text('task with schedule')
      task.tag.should == "070102 070103"
      task.load_tagging_value
      task.tagging_value["070102"][:from].should == Time.parse("2007 1/2 3:30")
      task.tagging_value["070103"][:from].should == Time.parse("2007 1/3 12:34")
    end
  end

  it "can parse hh:mm string" do
    @user.with_myscope do
      task = Task.create :text=>'task with schedule'
      task.tagging_value["070102"][:from] = "13:30"
      task.tagging_value["070102"][:to] = "15:00"
      task.tag = "070102"
      task.save!

      sch = Schedule.find(:first)
      sch.should_not be_nil
      sch.date.should == Date.new(2007, 1, 2)
      sch.from.should == Time.parse("2007-1-2 13:30")
      sch.to.should == Time.parse("2007-1-2 15:00")
    end
  end
end
