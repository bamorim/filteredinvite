require 'test_helper'

class InviteControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get invite" do
    get :invite
    assert_response :success
  end

end
