require File.dirname(__FILE__) + '/../test_helper'
require 'attachments_controller'

# Re-raise errors caught by the controller.
class AttachmentsController; def rescue_action(e) raise e end; end

class AttachmentsControllerTest < Test::Unit::TestCase
  use_all_fixtures
  
  def setup
    @controller = AttachmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create
    post :create, :photo => {
      :uploaded_data => fixture_file_upload("images/groupswiki.jpg")
    }

    assert_response :success
    assert_match /window.dialog/, @response.body
  end
end
