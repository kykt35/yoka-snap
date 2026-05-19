require "test_helper"

class ApplicationBasicAuthTest < ActionDispatch::IntegrationTest
  BASIC_AUTH_USERNAME = "staging-user"
  BASIC_AUTH_PASSWORD = "staging-password"

  setup do
    @original_basic_auth_enabled = ENV["BASIC_AUTH_ENABLED"]
    @original_basic_auth_username = ENV["BASIC_AUTH_USERNAME"]
    @original_basic_auth_password = ENV["BASIC_AUTH_PASSWORD"]
  end

  teardown do
    ENV["BASIC_AUTH_ENABLED"] = @original_basic_auth_enabled
    ENV["BASIC_AUTH_USERNAME"] = @original_basic_auth_username
    ENV["BASIC_AUTH_PASSWORD"] = @original_basic_auth_password
  end

  test "does not require basic authentication when disabled" do
    disable_basic_authentication

    get posts_path

    assert_response :success
  end

  test "requires basic authentication when enabled" do
    enable_basic_authentication

    get posts_path

    assert_response :unauthorized
  end

  test "allows access with valid basic authentication credentials" do
    enable_basic_authentication

    get posts_path, headers: basic_auth_headers(BASIC_AUTH_USERNAME, BASIC_AUTH_PASSWORD)

    assert_response :success
  end

  test "rejects invalid basic authentication credentials" do
    enable_basic_authentication

    get posts_path, headers: basic_auth_headers(BASIC_AUTH_USERNAME, "wrong-password")

    assert_response :unauthorized
  end

  test "does not require basic authentication for health check" do
    enable_basic_authentication

    get rails_health_check_path

    assert_response :success
  end

  private
    def enable_basic_authentication
      ENV["BASIC_AUTH_ENABLED"] = "true"
      ENV["BASIC_AUTH_USERNAME"] = BASIC_AUTH_USERNAME
      ENV["BASIC_AUTH_PASSWORD"] = BASIC_AUTH_PASSWORD
    end

    def disable_basic_authentication
      ENV["BASIC_AUTH_ENABLED"] = nil
      ENV["BASIC_AUTH_USERNAME"] = nil
      ENV["BASIC_AUTH_PASSWORD"] = nil
    end

    def basic_auth_headers(username, password)
      {
        "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
      }
    end
end
