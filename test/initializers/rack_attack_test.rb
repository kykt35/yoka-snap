require "test_helper"

class RackAttackTest < ActiveSupport::TestCase
  setup do
    @store = ActiveSupport::Cache::MemoryStore.new
    Rack::Attack.cache.store = @store
  end

  teardown do
    @store.clear
    Rack::Attack.cache.store = Rails.cache
  end

  test "throttles login attempts by ip" do
    throttle = Rack::Attack.throttles.fetch("logins/ip")
    request = Rack::Attack::Request.new(
      Rack::MockRequest.env_for("/session", method: "POST", "REMOTE_ADDR" => "203.0.113.10")
    )

    10.times { assert_not throttle.matched_by?(request) }
    assert throttle.matched_by?(request)
    assert_equal "203.0.113.10", request.env["rack.attack.match_data"][:discriminator]
    assert_equal 10, throttle.limit
    assert_equal 3.minutes, throttle.period
  end

  test "throttles password reset requests by ip" do
    throttle = Rack::Attack.throttles.fetch("password resets/ip")
    request = Rack::Attack::Request.new(
      Rack::MockRequest.env_for("/passwords", method: "POST", "REMOTE_ADDR" => "203.0.113.11")
    )

    10.times { assert_not throttle.matched_by?(request) }
    assert throttle.matched_by?(request)
    assert_equal "203.0.113.11", request.env["rack.attack.match_data"][:discriminator]
    assert_equal 10, throttle.limit
    assert_equal 3.minutes, throttle.period
  end

  test "throttles general requests by ip" do
    throttle = Rack::Attack.throttles.fetch("requests/ip")
    request = Rack::Attack::Request.new(
      Rack::MockRequest.env_for("/", method: "GET", "REMOTE_ADDR" => "203.0.113.12")
    )

    assert_not throttle.matched_by?(request)
    assert_equal "203.0.113.12", request.env["rack.attack.throttle_data"]["requests/ip"][:discriminator]
    assert_equal 300, throttle.limit
    assert_equal 5.minutes, throttle.period
  end

  test "safelists health checks" do
    safelist = Rack::Attack.safelists.fetch("allow health checks")
    request = Rack::Attack::Request.new(Rack::MockRequest.env_for("/up"))

    assert safelist.matched_by?(request)
  end
end
