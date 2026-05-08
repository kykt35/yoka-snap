require "test_helper"

class WantToGoPostsControllerTest < ActionDispatch::IntegrationTest
  test "requires login" do
    get want_to_go_posts_path

    assert_redirected_to new_session_path
  end

  test "shows saved published posts only" do
    sign_in_as users(:two)

    get want_to_go_posts_path

    assert_response :success
    assert_includes response.body, posts(:published).title
    assert_not_includes response.body, posts(:hidden).title
  end
end
