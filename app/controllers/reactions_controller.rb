class ReactionsController < ApplicationController
  before_action :set_post
  before_action :set_reaction_type

  def create
    Current.user.reactions.find_or_create_by!(post: @post, reaction_type: @reaction_type)
    redirect_back fallback_location: @post
  end

  def destroy
    Current.user.reactions.where(post: @post, reaction_type: @reaction_type).destroy_all
    redirect_back fallback_location: @post
  end

  private
    def set_post
      @post = Post.published.find(params[:post_id])
    end

    def set_reaction_type
      @reaction_type = params[:reaction_type].to_s
      raise ActiveRecord::RecordNotFound unless Reaction::TYPES.include?(@reaction_type)
    end
end
