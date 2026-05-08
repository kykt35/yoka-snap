require "test_helper"

class ReactionTest < ActiveSupport::TestCase
  test "prevents duplicate reaction type per user and post" do
    reaction = users(:one).reactions.build(post: posts(:published), reaction_type: "like")
    assert_not reaction.valid?
  end

  test "allows different reaction types for same user and post" do
    reaction = users(:one).reactions.build(post: posts(:published), reaction_type: "want_to_go")
    assert reaction.valid?
  end
end
