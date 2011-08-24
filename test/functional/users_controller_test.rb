require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user = users(:one)

  end
# 使用しない
=begin
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end
=end
# 使用しない
=begin
  test "should get new" do
    get :new
    assert_response :success
  end
=end

# 使用しない
=begin
  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
				email: "testuser1@falconsrv.net",
				password: "hogehogetest",
			}
    end
    assert_redirected_to user_path(assigns(:user))
  end
=end

  test "should show user" do
    get :show, id: @user.to_param
    assert_response :success
  end
# 使用しない
=begin
  test "should get edit" do
    get :edit, id: @user.to_param
    assert_response :success
  end
=end

# 使用しない
=begin
  test "should not update not_authorized_user" do
    put :update, id: @user.to_param, user: @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end
=end

# 使用しない
=begin
  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.to_param
    end

    assert_redirected_to users_path
  end
=end

end
