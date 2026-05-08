module Admin
  class PostsController < BaseController
    def index
      @posts = Post.includes(:user, :tags, images_attachments: :blob).newest
    end

    def show
      @post = Post.includes(:user, :tags, images_attachments: :blob).find(params[:id])
    end

    def publish
      update_status("published", "公開しました。")
    end

    def hide
      update_status("hidden", "非公開にしました。")
    end

    private
      def update_status(status, message)
        post = Post.find(params[:id])
        post.update!(status: status)
        redirect_to admin_post_path(post), notice: message
      end
  end
end
