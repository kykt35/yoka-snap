class PostsController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  def index
    @tags = Tag.order(:name)
    @areas = Post::AREAS
    @selected_tag = Tag.find_by(slug: params[:tag])
    @posts = Post.published.includes(:tags, images_attachments: :blob, reactions: :user).newest
    @posts = @posts.by_area(params[:area])
    @posts = @posts.tagged_with(params[:tag])
  end

  def show
    @post = Post.published.includes(:tags, images_attachments: :blob, reactions: :user).find(params[:id])
  end

  def new
    @post = Current.user.posts.build(status: "published")
  end

  def create
    @post = Current.user.posts.build(post_params)
    @post.status = "published"

    if @post.save
      redirect_to @post, notice: "投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :description, :area, :address, :recommended_time, images: [], tag_ids: [])
    end
end
