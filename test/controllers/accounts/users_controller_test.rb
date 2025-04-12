require "test_helper"

class Accounts::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "update" do
    assert_not users(:david).admin?

    put user_url(users(:david)), params: { user: { role: "admin" } }

    assert_redirected_to users_path
    assert users(:david).reload.admin?
  end

  test "can't promote to special roles" do
    assert_no_changes -> { users(:david).reload.role } do
      put user_url(users(:david)), params: { user: { role: "system" } }
    end
  end

  test "destroy" do
    assert_difference -> { User.active.count }, -1 do
      delete user_url(users(:david))
    end

    assert_redirected_to users_path
    assert_nil User.active.find_by(id: users(:david).id)
  end

  test "non-admins cannot perform actions" do
    sign_in_as :jz

    put user_url(users(:david)), params: { user: { role: "admin" } }
    assert_response :forbidden

    delete user_url(users(:david))
    assert_response :forbidden
  end
end
