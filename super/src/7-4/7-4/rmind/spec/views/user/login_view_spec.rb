require File.dirname(__FILE__) + '/../../spec_helper'

describe "/user/login" do
  before do
    render 'user/login'
  end

  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should render_template("user/login")
    response.should have_tag("form")
    response.should have_tag("input")
  end
end
