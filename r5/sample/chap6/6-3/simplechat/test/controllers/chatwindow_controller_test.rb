require 'test_helper'

class ChatwindowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chatwindow_index_url
    assert_response :success
  end

end
