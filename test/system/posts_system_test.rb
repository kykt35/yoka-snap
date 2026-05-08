require "application_system_test_case"

class PostsSystemTest < ApplicationSystemTestCase
  test "visitor can browse published posts on mobile width" do
    visit root_path

    assert_text "よかスナップ"
    assert_text posts(:published).title
    assert_no_text posts(:hidden).title
  end
end
