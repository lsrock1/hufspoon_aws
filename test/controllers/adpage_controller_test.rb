require 'test_helper'

class AdpageControllerTest < ActionController::TestCase
  test "should get dbmain" do
    get :dbmain
    assert_response :success
  end

  test "should get existmenu" do
    get :existmenu
    assert_response :success
  end

  test "should get remenu" do
    get :remenu
    assert_response :success
  end

end
