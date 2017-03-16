require 'test_helper'

class CollegeVerificationControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get completed" do
    get :completed
    assert_response :success
  end

  test "should get payment" do
    get :payment
    assert_response :success
  end

end
