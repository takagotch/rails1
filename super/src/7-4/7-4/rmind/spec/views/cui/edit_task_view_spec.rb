require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/cui/edit_task" do
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('abcd')
    task = cmd.task
    task.tag = "xyz"
    task.save!
    assigns[:task] = task
    assigns[:user] = @user
    render "cui/edit_task", :id=>task.id
  end

  it "should be valid" do
    #puts response.body
    response.should have_tag("form[action=/cui/edit_task]")
    response.should have_tag("form[action=/cui/edit_task]") do
      response.should have_tag("table") do
        with_tag("tr") do
          with_tag("th", "Text")
          with_tag('input[id="task_text"][value="abcd"]')
        end
        with_tag("tr") do
          with_tag("th", "Tag")
          with_tag('input[id="tag"][value="xyz"]')
        end
      end
    end
  end
end

describe "/cui/edit_task with schedule" do
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('1234')
    task = cmd.task
    task.tagging_value["20080809"][:from] = '05:06'
    task.tagging_value["20080809"][:to] = '07:08'
    task.tagging_value["20080809"][:preparation] = '9'
    task.tagging_value["20080809"][:place] = '10'
    task.tagging_value["20080809"][:memo] = "11\n12\n13\n"
    task.tag = "20080809"
    task.save!
    assigns[:user] = @user
    assigns[:task] = task
    render "cui/edit_task", :id=>task.id
  end

  it "should be valid" do
    #puts response.body
    response.should have_tag("form[action=/cui/edit_task]")
    response.should have_tag("form[action=/cui/edit_task]") do
      response.should have_tag("table") do
        with_tag("tr") do
          with_tag("th", "Text")
          with_tag('input[id="task_text"][value="1234"]')
        end
      end
      response.should have_tag("table") do
        with_tag("tr") do
          with_tag("th", "Schedule for")
          with_tag("td", "2008-08-09")
        end
        with_tag("tr") do
          with_tag("th", "From:")
          with_tag("td") do
            with_tag("input[value='05:06']")
          end
        end
        with_tag("tr") do
          with_tag("th", "Preparation:")
          with_tag("td") do
            with_tag("input[value='9']")
          end
        end
        with_tag("tr") do
          with_tag("th", "Place:")
          with_tag("td") do
            with_tag("input[value='10']")
          end
        end
        with_tag("tr") do
          with_tag("th", "Memo:")
          with_tag("td") do
            with_tag("textarea", "11\n12\n13\n")
          end
        end
      end
    end
  end
end

__END__
end
        with_tag("tr") do
          with_tag("th", "Tag")
          with_tag("input")
        end
      end
    end
  end
end

describe "/cui/edit_task with tags" do
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('abc')
    task = cmd.task
    task.tag = "20070801"
    task.tagging_value["20070801"][:place] = 'somewhere'
    assigns[:task] = task
    render "cui/edit_task", :id=>task.id
  end

  it "should be valid" do
    response.should have_tag("inbox[name=tv[200708101]")
  end
end
