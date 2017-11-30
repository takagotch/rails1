require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/tasks/show.rhtml" do
  include TasksHelper
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('xyz')
    assigns[:task] = cmd.task
  end

  it "should render attributes in <p>" do
    render "/tasks/show"
  end
end

describe "/tasks/show.rhtml", "task with memo" do
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

  it "should render attributes in <p>" do
    render "/tasks/show"
    response.should have_tag('tr') do
      with_tag('th', 'Memo:')
      with_tag('td', 'abc')
    end

  end
end
