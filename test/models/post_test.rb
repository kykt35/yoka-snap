require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "published scope only returns published posts" do
    assert_includes Post.published, posts(:published)
    assert_not_includes Post.published, posts(:hidden)
  end

  test "requires valid status and area" do
    post = users(:one).posts.build(title: "test", area: "Invalid", address: "Somewhere", status: "published")
    attach_test_image(post)
    assert_not post.valid?
    assert post.errors[:area].any?
  end

  test "requires at least one image" do
    post = users(:one).posts.build(title: "test", area: "博多", address: "博多駅", status: "published")
    assert_not post.valid?
    assert post.errors[:images].any?
  end
end
