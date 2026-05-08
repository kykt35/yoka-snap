require "test_helper"

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    attach_test_image(posts(:published)) unless posts(:published).images.attached?
  end

  test "requires login" do
    get admin_posts_path

    assert_redirected_to new_session_path
  end

  test "rejects non admins" do
    sign_in_as users(:one)

    get admin_posts_path

    assert_redirected_to root_path
  end

  test "admin can see posts" do
    sign_in_as users(:two)

    get admin_posts_path

    assert_response :success
    assert_includes response.body, posts(:published).title
    assert_includes response.body, posts(:hidden).title
  end

  test "admin can hide and publish post" do
    sign_in_as users(:two)
    post = posts(:published)

    patch hide_admin_post_path(post)
    assert_redirected_to admin_post_path(post)
    assert_equal "hidden", post.reload.status

    patch publish_admin_post_path(post)
    assert_redirected_to admin_post_path(post)
    assert_equal "published", post.reload.status
  end
end
