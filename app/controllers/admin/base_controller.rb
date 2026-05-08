module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private
      def require_admin
        redirect_to root_path, alert: "管理者のみアクセスできます。" unless Current.admin?
      end
  end
end
