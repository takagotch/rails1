require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/tasks/index.rhtml" do
  include TasksHelper
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('xyz')
    task1 = cmd.task
    cmd = @user.commands.do_create_task('abc')
    task2 = cmd.task

    assigns[:tasks] = [task1, task2]
    assigns[:tasks_by_date] = Task.tasks_by_date(assigns[:tasks], :created_at)

  end

  it "should render list of tasks" do
    render "/tasks/index"
  end
end

