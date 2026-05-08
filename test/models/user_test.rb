require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(name: "Test", email_address: " DOWNCASED@EXAMPLE.COM ", password: "password")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "avatar can be attached" do
    user = users(:one)
    user.avatar.attach(io: file_fixture("avatar.png").open, filename: "avatar.png", content_type: "image/png")
    assert user.avatar.attached?
  end
end
