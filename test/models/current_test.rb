require "test_helper"

class CurrentTest < ActiveSupport::TestCase
  teardown do
    Current.reset
  end

  test "admin predicate is true when current user has admin role" do
    Current.session = users(:two).sessions.create!

    assert Current.admin?
  end

  test "admin predicate is false for regular user" do
    Current.session = users(:one).sessions.create!

    assert_not Current.admin?
  end

  test "admin predicate is false without current user" do
    assert_not Current.admin?
  end
end
