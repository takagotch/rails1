require File.dirname(__FILE__) + '/../test_helper'
require 'paypal_controller'

# Re-raise errors caught by the controller.
class PaypalController; def rescue_action(e) raise e end; end

class PaypalControllerTest < Test::Unit::TestCase
  def setup
    @controller = PaypalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
