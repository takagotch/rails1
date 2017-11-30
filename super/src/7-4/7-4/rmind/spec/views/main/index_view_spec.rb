require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "SetNullIndex", :shared => true do
  before(:each) do
    assigns[:user] = @user
    assigns[:inbox] = []
    assigns[:next_actions] = []
    assigns[:schedules] = []
    assigns[:tasks_done] = []
    assigns[:project_to_review] = []
    assigns[:sch] = Time.now
    assigns[:done_since] = Time.now
  end
end

describe "/main/index" do
  it_should_behave_like "TestWithOneUser"
  it_should_behave_like "SetNullIndex"

  before do
    cmd = @user.commands.do_create_task('xyz')
    task = cmd.task
    assigns[:inbox] = [task]
    render 'main/index'
  end

  it "index" do
    response.should have_tag('div#inbox_area') do
      with_tag('h2', "Inbox")
    end
  end
end

describe "/main/index show_task" do
  it_should_behave_like "TestWithOneUser"
  it_should_behave_like "SetNullIndex"

  before do
    t1 = @user.commands.do_create_task('abc').task
    t2 = @user.commands.do_create_task('xyz').task
    assigns[:inbox] = [t1, t2]
    assigns[:current_task] = t1
    render 'main/index'
  end

  it "index and show task" do
    #IO.popen("tidy -indent -xml", "w").write response.body
    response.body.should match(/abc/)
    response.body.should match(/xyz/)
    response.should have_tag('div#inbox_area') do
      with_tag('h2', "Inbox")
    end
  end
end

describe "/main/index edit_task" do
  it_should_behave_like "TestWithOneUser"
  it_should_behave_like "SetNullIndex"

  before do
    t1 = @user.commands.do_create_task('abc').task
    t2 = @user.commands.do_create_task('xyz').task
    assigns[:user] = @user
    assigns[:inbox] = [t1, t2]
    assigns[:current_task] = t1
    assigns[:cmd] = 'edit'
    render 'main/index'
  end

  it "index and edit task" do
    #IO.popen("tidy -indent -xml", "w").write response.body
    response.body.should match(/abc/)
    response.body.should match(/xyz/)
    response.should have_tag('div#inbox_area') do
      with_tag('h2', "Inbox")
    end
  end
end

describe "/main/index edit_tag" do
  it_should_behave_like "TestWithOneUser"
  it_should_behave_like "SetNullIndex"

  before do
    t1 = @user.commands.do_create_task('abc').task
    t2 = @user.commands.do_create_task('xyz').task
    assigns[:user] = @user
    assigns[:inbox] = [t1, t2]
    assigns[:current_task] = t1
    assigns[:cmd] = 'tag_edit'
    render 'main/index'
  end

  it "index and edit task" do
    #IO.popen("tidy -indent -xml", "w").write response.body
    response.body.should match(/abc/)
    response.body.should match(/xyz/)
    response.should have_tag('div#inbox_area') do
      with_tag('h2', "Inbox")
    end
  end
end

describe "/main/index next_actions" do
  it_should_behave_like "TestWithOneUser"
  it_should_behave_like "SetNullIndex"

  before do
    cmd = @user.commands.do_create_task('xyz')
    task = cmd.task
    @user.commands.do_update_task(task.id, :tag=>'@office')
    assigns[:next_actions] = [task.reload]
    assigns[:na] = { }
    render 'main/index'
  end

  it "index" do
    #IO.popen("tidy -indent -xml", "w").write response.body
    response.body.should match(/xyz/)
    response.should have_tag('div#next_actions_area') do
      with_tag('h2', "Next Actions")
      with_tag('div#next_actions') do
        with_tag('table') do
          with_tag('tr') do
            with_tag('th', 'project')
            with_tag('th', 'task')
            with_tag('th', 'tag')
          end

          with_tag('tr') do
            with_tag('td') do
              with_tag('a', 'root')
            end
            with_tag('td') do
              with_tag('div') do
                with_tag('a', 'xyz')
              end
            end
            with_tag('td') do
              with_tag('a', '@office')
            end
          end
        end
      end
    end
  end
end

describe "/main/index project_select" do
  it_should_behave_like "TestWithOneUser"
  it_should_behave_like "SetNullIndex"

  before do
    t1 = @user.commands.do_create_task('abc').task
    t2 = @user.commands.do_create_task('xyz').task
    @user.commands.do_update_task(t1.id, :tag=>'@office')
    @user.commands.do_update_task(t2.id, :tag=>'@office')
    assigns[:user] = @user
    assigns[:next_actions] = [t1.reload, t2.reload]
    assigns[:current_task] = t1
    assigns[:cmd] = 'project_select'
    assigns[:na] = { }
    render 'main/index'
  end

  it "index and edit task" do
    #IO.popen("tidy -indent -xml", "w").write response.body
    response.body.should match(/abc/)
    response.body.should match(/xyz/)
    response.should have_tag('div#next_actions')
  end
end
