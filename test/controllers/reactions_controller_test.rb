require "test_helper"

class ReactionsControllerTest < ActionDispatch::IntegrationTest
  test "requires login to like" do
    post post_reactions_path(posts(:published), reaction_type: :like)

    assert_redirected_to new_session_path
  end

  test "creates like once" do
    sign_in_as users(:two)

    assert_difference("Reaction.like.count", 1) do
      post post_reactions_path(posts(:published), reaction_type: :like)
    end
    assert_no_difference("Reaction.like.count") do
      post post_reactions_path(posts(:published), reaction_type: :like)
    end
  end

  test "destroys like" do
    sign_in_as users(:one)

    assert_difference("Reaction.like.count", -1) do
      delete post_reaction_path(posts(:published), reaction_type: :like)
    end
  end

  test "creates and destroys want to go" do
    sign_in_as users(:one)

    assert_difference("Reaction.want_to_go.count", 1) do
      post post_reactions_path(posts(:published), reaction_type: :want_to_go)
    end
    assert_difference("Reaction.want_to_go.count", -1) do
      delete post_reaction_path(posts(:published), reaction_type: :want_to_go)
    end
  end
end
