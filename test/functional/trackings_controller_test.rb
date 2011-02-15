require 'test_helper'

class TrackingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trackings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tracking" do
    assert_difference('Tracking.count') do
      post :create, :tracking => { }
    end

    assert_redirected_to tracking_path(assigns(:tracking))
  end

  test "should show tracking" do
    get :show, :id => trackings(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => trackings(:one).to_param
    assert_response :success
  end

  test "should update tracking" do
    put :update, :id => trackings(:one).to_param, :tracking => { }
    assert_redirected_to tracking_path(assigns(:tracking))
  end

  test "should destroy tracking" do
    assert_difference('Tracking.count', -1) do
      delete :destroy, :id => trackings(:one).to_param
    end

    assert_redirected_to trackings_path
  end
end
