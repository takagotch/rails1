require 'test_helper'

class WorkmenuControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get workmenu_index_url
    assert_response :success
  end

end
