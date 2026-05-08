require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "sets slug from name" do
    tag = Tag.create!(name: "動画向き")
    assert_equal "動画向き", tag.slug
  end
end
