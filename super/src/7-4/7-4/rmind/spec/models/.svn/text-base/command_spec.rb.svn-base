require File.dirname(__FILE__) + '/../spec_helper'
require 'spec/common'
require 'tag'

# dummy for loading command.rb
describe Command do
  it_should_behave_like "TestWithOneUser"

  it "should be valid" do
    Time.with_mock_time do
      cmd = CreateTaskCommand.create(@user, 'xxx')
      cmd.should be_valid
      cmd.do
      cmd.done_at.should_not be_nil
      cmd.destroy
    end
  end

  it "has command stack of 10 per one user " do
    Time.with_mock_time do
      %w(1 2 3 4 5 6 7 8 9 0 x).each do |n|
        @user.commands.do_create_task(n)
        Time.advance(1)
      end
    end

    @user.should have(10).commands
    @user.should have(11).tasks
    @user.tasks.find_by_text('x').should_not be_nil
    @user.last_command.should be_kind_of(CreateTaskCommand)
    @user.last_command.task.text.should == 'x'
    @user.commands.undo
    @user.tasks.find_by_text('x').should be_nil
    @user.commands.reload
    @user.should have(9).commands
    @user.tasks.reload
    @user.should have(10).tasks

    %w(2 3 4 5 6 7 8 9 0).reverse.each_with_index do |n, cnt|
      @user.tasks.find_by_text(n).should_not be_nil
      @user.commands.undo
      @user.tasks.reload
      @user.tasks.find_by_text(n).should be_nil
      @user.commands.reload
      @user.should have(8-cnt).commands
      @user.should have(9-cnt).tasks
    end

    @user.should have(0).commands
    @user.should have(1).tasks
    proc { @user.commands.undo }.should raise_error
    @user.tasks.first.destroy
  end
end

describe CreateTaskCommand, "create task" do
  it_should_behave_like "TestWithOneUser"

  it "creates new task" do
    command = @user.commands.do_create_task('aaa')
    command.task.text.should == 'aaa'
    @user.tasks.reload
    @user.should have(1).inbox
    @user.tasks.find_by_text('aaa').should_not be_nil
    @user.inbox.first.text.should == 'aaa'
  end

  it "can undo" do
    command = @user.commands.do_create_task('aaa')
    @user.should have(1).inbox
    @user.tasks.find_by_text('aaa').should_not be_nil
    @user.inbox.first.text.should == 'aaa'
    command.undo
    @user.should have(0).inbox
    @user.tasks.find_by_text('aaa').should be_nil
  end
end

describe UpdateTaskCommand do
  it_should_behave_like "TestWithOneUser"

  it "updates a task" do
    command = @user.commands.do_create_task('aaa')
    @user.commands.do_update_task(command.task.id, :text=>'bbb')
    task = command.task.reload
    task.text.should == 'bbb'
    @user.tasks.find_by_text('aaa').should be_nil
    @user.tasks.find_by_text('bbb').should_not be_nil
  end

  it "updates tags of a task" do
    command = @user.commands.do_create_task('aaa')
    task = command.task
    @user.commands.do_update_task(task.id, :tag=>'xxx yyy')
    task.reload
    task.tag.should == 'xxx yyy'
    @user.tags.find_by_name('xxx').tasks.first.should == task
    @user.tags.find_by_name('yyy').tasks.first.should == task
  end


  it "can undo" do
    Time.with_mock_time("2007-08-19 13:46") do
      command = @user.commands.do_create_task('aaa')
      Time.advance(1.minute)
      task = command.task
      command = @user.commands.do_update_task(task.id, :text=>'bbb')
      task.reload
      task.text.should == 'bbb'
      task.updated_at.should == Time.parse("2007-08-19 13:47")
      task_id = task.id
      Time.advance(1.minute)
      command.undo

      task = Task.find(task_id)
      task.text.should == 'aaa'
      task.updated_at = Time.parse("2007-08-19 13:47")
    end
  end

  it "updates tagging value of a task" do
    memotag = MemoTag.create(:user=>@user, :name => 'memo')
    command = @user.commands.do_create_task('aaa')
    task = command.task
    tagging_value = {
      'memo' => { :memo => 'xyz' }
    }
    command = @user.commands.do_update_task(task.id, { :tag=>'xxx memo' }, tagging_value)

    memo = Memo.find(:first)
    memo.memo.should == 'xyz'
    task.reload
    task.tag.should == 'memo xxx'
    task.load_tagging_value
    task.tagging_value['memo'][:memo].should == 'xyz'

    command.undo
    task.reload
    task.tag.should == ''
    Memo.count.should == 0
  end
end

describe TaskStatusCommand do
  it_should_behave_like "TestWithOneUser"

  it "makes a task done" do
    task = @user.commands.do_create_task('aaa').task
    task.status.should_not == Task::Status::Done
    @user.commands.do_task_done(task)
    task.reload
    task.status.should == Task::Status::Done
    @user.commands.undo
    task.reload
    task.status.should_not == Task::Status::Done
  end

  it "makes a task undone" do
    Time.with_mock_time do
      task = @user.commands.do_create_task('aaa').task
      Time.advance(1.day)
      task.status.should_not == Task::Status::Done
      @user.commands.do_task_done(task)
      done_at = task.reload.done_at
      done_at.should == Time.now
      Time.advance(1.day)
      task.reload
      task.status.should == Task::Status::Done
      @user.commands.do_task_undone(task)
      Time.advance(1.day)
      task.reload
      task.status.should_not == Task::Status::Done
      @user.commands.undo
      Time.advance(1.day)
      task.reload
      task.status.should == Task::Status::Done
      task.done_at.should == done_at
    end
  end

  it "makes a task trash" do
    Time.with_mock_time do
      task = @user.commands.do_create_task('aaa').task
      task.status.should_not == Task::Status::Trashed
      Time.advance(1.day)
      @user.commands.do_task_trash(task)
      task.reload
      task.status.should == Task::Status::Trashed
      Time.advance(1.day)
      @user.commands.undo
      task.reload
      task.status.should_not == Task::Status::Trashed
    end
  end

  it "makes a task untrash" do
    Time.with_mock_time do
      task = @user.commands.do_create_task('aaa').task
      task.status.should_not == Task::Status::Trashed
      Time.advance(1.day)
      @user.commands.do_task_trash(task)
      task.reload
      task.status.should == Task::Status::Trashed
      trashed_at = task.trashed_at
      trashed_at.should == Time.now
      Time.advance(1.day)
      @user.commands.do_task_untrash(task)
      task.status.should_not == Task::Status::Trashed
      Time.advance(1.day)
      @user.commands.undo
      task.reload
      task.status.should == Task::Status::Trashed
      task.trashed_at.should == trashed_at
    end
  end
end

describe MoveTaskCommand do
  it_should_behave_like "TestWithOneUser"

  before do
    @prj1 = @user.commands.do_create_project(@user.root_project, 'prj1').project
    @task = @user.commands.do_create_task('aaa').task
  end

  it "moves a task to another project" do
    @task.project.should_not == @prj1
    @user.commands.do_move_task(@task.id, @prj1.id)
    @task.reload.project.should == @prj1
  end

  it "can undo" do
    @task.project.should_not == @prj1
    @user.commands.do_move_task(@task.id, @prj1.id)
    @task.reload.project.should == @prj1
    @user.commands.undo
    @task.reload.project.should_not == @prj1
  end
end

describe TaskToProjectCommand do
  it_should_behave_like "TestWithOneUser"

  before do
    Time.with_mock_time do
      @prj1 = @user.commands.do_create_project(@user.root_project, 'prj1').project
      @task = @user.commands.do_create_task('aaa').task
      @task.project = @prj1
      @task.save!
    end
  end

  it "convert task to project" do
    @prj1.should have(0).sub_projects
    @user.commands.do_task_to_project(@task)
    @prj1.reload.should have(1).sub_projects
    new_prj = @prj1.reload.sub_projects.first
    @task.reload.project.should == new_prj
    new_prj.name.should == @task.text
    new_prj.parent.should == @prj1
    new_prj.review_interval.should == @prj1.review_interval
  end

  it "can undo" do
    @user.commands.do_task_to_project(@task)
    @prj1.should have(1).sub_projects
    @user.commands.undo
    @prj1.reload.should have(0).sub_projects
    @task.reload.project.should == @prj1
  end
end
