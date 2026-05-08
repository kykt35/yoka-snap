require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "index shows only published posts" do
    get posts_path

    assert_response :success
    assert_includes response.body, posts(:published).title
    assert_not_includes response.body, posts(:hidden).title
  end

  test "index filters by area" do
    get posts_path(area: "糸島")

    assert_response :success
    assert_includes response.body, posts(:published).title
  end

  test "index filters by tag" do
    get posts_path(tag: tags(:sea).slug)

    assert_response :success
    assert_includes response.body, posts(:published).title
    assert_not_includes response.body, posts(:hidden).title
  end

  test "show renders a published post" do
    get post_path(posts(:published))

    assert_response :success
    assert_includes response.body, posts(:published).title
  end

  test "show does not render hidden post" do
    get post_path(posts(:hidden))

    assert_response :not_found
  end

  test "new requires login" do
    get new_post_path

    assert_redirected_to new_session_path
  end

  test "logged in user renders new post form" do
    sign_in_as users(:one)

    get new_post_path

    assert_response :success
    assert_select "form"
    assert_select "input[type=file][name='post[images][]']"
    assert_select "input[type=submit][value='投稿する']"
  end

  test "logged in user creates published post with an image" do
    sign_in_as users(:one)

    assert_difference("Post.count") do
      post posts_path, params: {
        post: {
          title: "天神の路地",
          area: "天神・大名",
          address: "天神",
          description: "歩いていて見つけた路地",
          recommended_time: "昼",
          tag_ids: [ tags(:cafe).id ],
          images: [ fixture_file_upload("photo.png", "image/png") ]
        }
      }
    end

    created_post = Post.order(:created_at).last
    assert_equal "published", created_post.status
    assert created_post.images.attached?
    assert_redirected_to post_path(created_post)
  end
end
