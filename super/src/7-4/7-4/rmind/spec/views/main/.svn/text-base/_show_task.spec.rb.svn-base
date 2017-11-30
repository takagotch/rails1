require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/main/_show_task" do
  it_should_behave_like "TestWithOneUser"

  before do
    assigns[:user] = @user
    cmd = @user.commands.do_create_task('xyz')
    assigns[:show_task] = cmd.task
    render 'main/_show_task'
  end

  it "view" do
    response.should have_tag('div#current_task_area') do
      with_tag('table') do
        with_tag('tr') do
          with_tag('th', 'Task:')
          with_tag('td', 'xyz')
        end
      end
    end
    response.should have_tag('a', "detail")
  end
end

