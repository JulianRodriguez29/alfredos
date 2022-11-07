require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:julian)
  end

  test "should get show" do
    get user_url(@user.username)
    assert_response :success
  end
end
