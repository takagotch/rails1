require File.dirname(__FILE__) + '/../../spec_helper'

describe "/tasks/new.rhtml" do
  include TasksHelper

  before do
    @task = mock_model(Task)
    @task.stub!(:new_record?).and_return(true)
    assigns[:task] = @task
  end

  it "should render new form" do
    render "/tasks/new"
  end
end


