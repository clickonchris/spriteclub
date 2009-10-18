require 'test_helper'

class ChallengesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:challenges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create challenge" do
    assert_difference('Challenge.count') do
      post :create, :challenge => { }
    end

    assert_redirected_to challenge_path(assigns(:challenge))
  end

  test "should show challenge" do
    get :show, :id => challenges(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => challenges(:one).id
    assert_response :success
  end

  test "should update challenge" do
    put :update, :id => challenges(:one).id, :challenge => { }
    assert_redirected_to challenge_path(assigns(:challenge))
  end

  test "should destroy challenge" do
    assert_difference('Challenge.count', -1) do
      delete :destroy, :id => challenges(:one).id
    end

    assert_redirected_to challenges_path
  end
end
