require File.dirname(__FILE__) + '/../../spec_helper'
require 'spec/common'

describe "/cui/inbox" do
  it_should_behave_like "TestWithOneUser"

  before do
    cmd = @user.commands.do_create_task('abc')
    t = cmd.task
    t.tag = "xyz"
    t.save!
    assigns[:inbox] = @user.inbox
    render 'cui/inbox'
  end

  it "should be valid" do
    response.should have_tag("table")do
      with_tag("tr") do
        with_tag("td", "abc")
        with_tag("td", "xyz")
        with_tag("td") do
          with_tag("a", "edit")
        end
      end
    end
  end
end
