class MyPagesController < ApplicationController
  def show
    @posts = Current.user.posts.includes(:tags, images_attachments: :blob, reactions: :user).newest
    @want_to_go_posts = Post.published
      .joins(:reactions)
      .where(reactions: { user: Current.user, reaction_type: "want_to_go" })
      .includes(:tags, images_attachments: :blob, reactions: :user)
      .newest
  end
end
