require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/tasks/edit.rhtml" do
  include ApplicationHelper
  include TasksHelper
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('xyz')
    assigns[:task] = cmd.task
    assigns[:user] = @user
  end

  it "should render edit form" do
    render "/tasks/edit"
  end
end

describe "/tasks/edit.rhtml", "task with memo" do
  include ApplicationHelper
  include TasksHelper
  it_should_behave_like "TestWithOneUser"

  before do
    task = @user.commands.do_create_task('xyz').task
    task.tag = 'memo'
    task.load_tagging_value
    task.tagging_value['memo'][:memo] = 'abc'
    task.save!
    assigns[:task] = task
    assigns[:user] = @user
  end

  it "should render edit form" do
    render "/tasks/edit"
    #puts response.body
    response.should have_tag('textarea', 'abc')
  end
end


