require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path # signupページへのパス
    # action="/signup"を共通化に伴い変更(自己判断)
    assert_select 'form[action="/users"]' # urlが違ったらエラーになるテスト
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {
         name: "", 
         email: "user@invalid", 
         password: "foo",
         password_confirmation: "bar"
        }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'li', 'Email is invalid'
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    assert_select 'li', "Name can't be blank"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
