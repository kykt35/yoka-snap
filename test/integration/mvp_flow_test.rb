require "test_helper"

class MvpFlowTest < ActionDispatch::IntegrationTest
  test "user can browse post save it and admin can hide it" do
    get root_path
    assert_response :success
    assert_includes response.body, posts(:published).title

    sign_in_as users(:one)

    assert_difference("Post.count", 1) do
      post posts_path, params: {
        post: {
          title: "百道の海辺",
          area: "百道・西新",
          address: "百道浜",
          description: "海と街が一緒に撮れる場所",
          recommended_time: "昼",
          tag_ids: [ tags(:sea).id ],
          images: [ fixture_file_upload("photo.png", "image/png") ]
        }
      }
    end

    created_post = Post.order(:created_at).last
    follow_redirect!
    assert_response :success
    assert_includes response.body, created_post.title

    assert_difference("Reaction.want_to_go.count", 1) do
      post post_reactions_path(created_post, reaction_type: :want_to_go)
    end

    get want_to_go_posts_path
    assert_response :success
    assert_includes response.body, created_post.title

    sign_out
    sign_in_as users(:two)
    patch hide_admin_post_path(created_post)
    assert_equal "hidden", created_post.reload.status

    sign_out
    get post_path(created_post)
    assert_response :not_found
  end
end
