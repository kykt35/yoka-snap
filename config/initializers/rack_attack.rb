class Rack::Attack
  Rack::Attack.cache.store = Rails.cache

  safelist("allow health checks") do |request|
    request.path == "/up"
  end

  throttle("requests/ip", limit: 300, period: 5.minutes) do |request|
    request.ip
  end

  throttle("logins/ip", limit: 10, period: 3.minutes) do |request|
    request.ip if request.post? && request.path == "/session"
  end

  throttle("password resets/ip", limit: 10, period: 3.minutes) do |request|
    request.ip if request.post? && request.path == "/passwords"
  end

  self.throttled_responder = lambda do |request|
    match_data = request.env["rack.attack.match_data"] || {}
    headers = { "Content-Type" => "text/plain" }

    if match_data[:period]
      retry_after = match_data[:period] - (match_data[:epoch_time] % match_data[:period])
      headers["Retry-After"] = retry_after.to_i.to_s
    end

    [ 429, headers, [ "Too many requests\n" ] ]
  end
end
