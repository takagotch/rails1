require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'

describe DashBoard, "inbox" do
  it_should_behave_like "TestWithOneUser"

  it "has tasks" do
    @user.should have(0).inbox
  end

  it "has all new tasks" do
    @user.commands.do_create_task('aaa')
    @user.should have(1).inbox
    @user.tasks.find_by_text('aaa').should_not be_nil
    @user.inbox.first.text.should == 'aaa'
  end

  it "has tasks older first" do
    create_tasks *%w(aaa bbb ccc)
    @user.should have(3).inbox
    inbox_tasks.should == %w(aaa bbb ccc)
    Time.with_mock_time("2007-02-01") do
      t = Task.find_by_text('bbb')
      t.use_record_timestamps = true
      t.save!
    end
    inbox_tasks.should == %w(aaa ccc bbb)
  end

  it "excludes tasks with context tag and schedule tag" do
    create_tasks *%w(aaa bbb ccc)
    @user.should have(3).inbox
    task = @user.tasks.find_by_text('aaa')
    task.tag = '@work'
    task.save!

    @user.should have(2).inbox
    inbox_tasks.should == %w(bbb ccc)

    task = @user.tasks.find_by_text('bbb')
    task.load_tagging_value
    task.tag = '20070101'
    task.save!

    @user.should have(1).inbox
    inbox_tasks.should == %w(ccc)

    t = @user.tasks.find_by_text('ccc')
    t.tag = "id:essa"
    t.save!
    @user.should have(0).inbox
  end

  it "excludes tasks already done and trashed" do
    create_tasks *%w(aaa bbb ccc)
    t = @user.tasks.find_by_text('aaa')
    t.tag = "task with normal tags should apear inbox"
    t.save!
    @user.should have(3).inbox

    t = @user.tasks.find_by_text('bbb')
    t.record_done
    t.save!
    @user.should have(2).inbox

    inbox_tasks.should == %w(aaa ccc)
    t = @user.tasks.find_by_text('ccc')
    t.trash
    t.save!
    @user.should have(1).inbox
    inbox_tasks.should == %w(aaa)

  end

  it "excludes tasks not in root project" do
    root = @user.root_project
    p1 = root.sub_projects.create(:name=>"p1")
    create_tasks *%w(aaa bbb ccc)
    @user.should have(3).inbox
    t = @user.tasks.find_by_text('bbb')
    p1.tasks << t
    t.save!
    @user.should have(2).inbox
    inbox_tasks.should == %w(aaa ccc)
    t = @user.tasks.find_by_text('ccc')
    p1.tasks << t
    t.save!
    @user.should have(1).inbox
    inbox_tasks.should == %w(aaa)
  end

  def create_tasks(*args)
    Time.with_mock_time("2007-01-01") do
      args.each do |text|
        @user.commands.do_create_task(text)
        Time.advance(1.day)
      end
    end
  end

  def inbox_tasks
    @user.inbox.collect { |t| t.text}
  end
end

describe DashBoard, "next_actions" do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    Tag # loding
    ContextTag.create(:user=>@user, :name=>'@work')
    ContextTag.create(:user=>@user, :name=>'@home')
  end

  it "has nothing when there is no next action" do
    na = @user.next_actions
    na.should == []
    task = @user.commands.do_create_task('aaa').task
    task.tag = 'aaa 20070101'
    task.save!
    na = @user.next_actions
    na.should == []
  end

  it "has next action" do
    task = @user.commands.do_create_task('aaa').task
    task.tag = '@work'
    task.save!
    na = @user.next_actions
    na.size.should == 1
    na.should == [task]
  end

  it "pick up next actions from other project" do
    prj = @user.root_project.sub_projects.create(:name=>'prj')
    task = @user.commands.do_create_task('aaa').task
    task.tag = '@work'
    task.project = prj
    task.save!
    na = @user.next_actions
    na.size.should == 1
    na.should == [task]
  end

  it "select context" do
    task = @user.commands.do_create_task('aaa').task
    task.tag = '@work'
    task.save!
    na = @user.next_actions('@work')
    na.size.should == 1
    na.should == [task]
    na = @user.next_actions('@home')
    na.size.should == 0
    na.should == []
  end

  it "select two context" do
    t1 = @user.commands.do_create_task('aaa').task
    t1.tag = '@work xxxx'
    t1.save!
    t2 = @user.commands.do_create_task('bbb').task
    t2.tag = '@home yyyy'
    t2.save!
    t3 = @user.commands.do_create_task('ccc').task
    t3.tag = 'xxxx'
    t3.save!

    na = @user.next_actions('@work')
    na.size.should == 1
    na.should == [t1]
    na.first.tag.should == t1.tag
    na = @user.next_actions('@home')
    na.size.should == 1
    na.should == [t2]
    na.first.tag.should == t2.tag
    na = @user.next_actions(%w(@home @work))
    na.size.should == 2
  end

  it "exclude done" do
    task = @user.commands.do_create_task('aaa').task
    task.tag = '@work'
    task.save!
    na = @user.next_actions
    na.size.should == 1
    na.should == [task]
    task.record_done.save!
    @user.next_actions.should == []
  end
end

describe DashBoard, "schedule" do
  it_should_behave_like "TestWithOneUser"

  it "has nothing when there is no schedule" do
    @user.should have(0).schedules
    @user.schedules.should == []
    task = @user.commands.do_create_task('aaa').task
    task.tag = 'aaa'
    task.save!
    @user.should have(0).schedules
    @user.schedules.should == []
  end

  it "has task with schedules" do
    task = @user.commands.do_create_task('aaa').task
    task.tag = '20070101 aaa'
    task.save!
    @user.should have(1).schedules
    @user.schedules.should == [task]
    @user.schedules.first.tag.should == task.tag
  end

  it "has tasks order by schedule date" do
    t1 = @user.commands.do_create_task('aaa').task
    t1.tag = 'aaa 20070101'
    t1.save!
    t2 = @user.commands.do_create_task('bbb').task
    t2.tagging_value['20070101'][:from] = '11:00'
    t2.tag = '20070101'
    t2.save!
    t3 = @user.commands.do_create_task('bbb').task
    t3.tagging_value['20070101'][:from] = '09:00'
    t3.tag = '20070101'
    t3.save!
    t4 = @user.commands.do_create_task('bbb').task
    t4.tag = '20070102'
    t4.save!
    @user.should have(4).schedules
    @user.schedules.should == [t1, t3, t2, t4]
    @user.schedules('20070101').size.should == 3
    @user.schedules('20070101').should == [t1, t3, t2]
  end
  it "exclude done" do
    task = @user.commands.do_create_task('aaa').task
    task.tag = 'aaa 20070101'
    task.save!
    @user.should have(1).schedules
    @user.schedules.should == [task]
    task.record_done.save!
    @user.should have(0).schedules
    @user.next_actions.should == []
  end
end

describe DashBoard, "projects_to_review" do
  it_should_behave_like "TestWithOneUser"

  before(:each) do
    @root = @user.root_project
    @user.commands.do_project_review(@root)
  end

  it "has nothing when there is no project to review" do
    Time.with_mock_time do
      @user.should have(0).project_to_review
      @user.project_to_review.should == []
      prj = @user.commands.do_create_project(@root.id, 'aaa').project
      prj.review_interval = 7 ;
      prj.save!

      @user.should have(1).project_to_review
      @user.project_to_review.should == [prj]
      @user.commands.do_project_review(prj)
      @user.should have(0).project_to_review
      @user.project_to_review.should == []

      Time.advance(7.days+1)
      @user.should have(1).project_to_review
      @user.project_to_review.should == [prj]
      @user.commands.do_project_review(prj)
      @user.should have(0).project_to_review
      @user.project_to_review.should == []

    end
  end
end
