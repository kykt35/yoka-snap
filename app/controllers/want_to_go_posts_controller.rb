class WantToGoPostsController < ApplicationController
  def index
    @posts = Post.published
      .joins(:reactions)
      .where(reactions: { user: Current.user, reaction_type: "want_to_go" })
      .includes(:tags, images_attachments: :blob, reactions: :user)
      .newest
  end
end
