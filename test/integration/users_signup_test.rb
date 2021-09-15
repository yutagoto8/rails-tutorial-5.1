require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path # signupページへのパス
    assert_select 'form[action="/signup"]' # urlが違ったらエラーになるテスト
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
end