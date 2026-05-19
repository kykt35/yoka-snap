class ApplicationController < ActionController::Base
  include Authentication
  helper_method :current_user
  before_action :require_basic_authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private
    def require_basic_authentication
      return unless basic_authentication_enabled?

      authenticate_or_request_with_http_basic("Yoka Snap Staging") do |username, password|
        basic_authentication_credentials_match?(username, password)
      end
    end

    def basic_authentication_enabled?
      ActiveModel::Type::Boolean.new.cast(ENV["BASIC_AUTH_ENABLED"])
    end

    def basic_authentication_credentials_match?(username, password)
      expected_username = ENV["BASIC_AUTH_USERNAME"]
      expected_password = ENV["BASIC_AUTH_PASSWORD"]

      return false if expected_username.blank? || expected_password.blank?

      ActiveSupport::SecurityUtils.secure_compare(username, expected_username) &
        ActiveSupport::SecurityUtils.secure_compare(password, expected_password)
    end

    def current_user
      Current.user
    end
end
