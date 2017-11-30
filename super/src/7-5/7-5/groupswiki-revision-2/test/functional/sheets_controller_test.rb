require File.dirname(__FILE__) + '/../test_helper'
require 'sheets_controller'

# Re-raise errors caught by the controller.
class SheetsController; def rescue_action(e) raise e end; end

class SheetsControllerTest < Test::Unit::TestCase
  def setup
    @controller = SheetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
