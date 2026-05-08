require "test_helper"

class AdminRoleTest < ActiveSupport::TestCase
  test "prevents duplicate admin role per user" do
    admin_role = AdminRole.new(user_id: users(:two).id)

    assert_not admin_role.valid?
  end
end
