# app/services/rate_limiter_service.rb
class RateLimiterService
  LIMIT  = 100        # requests
  WINDOW = 60         # seconds (1 minute)

  def initialize(user)
    @user = user
  end

  def allowed?
    key = cache_key
    count = RedisServer.incr(key)
    RedisServer.expire(key, WINDOW) if count == 1
    count <= LIMIT
  end

  def remaining_requests
    key = cache_key
    [LIMIT - RedisServer.get(key).to_i, 0].max
  end

  private

  def cache_key
    "rate_limit:user:#{@user.id}:#{Time.now.to_i / WINDOW}"
  end
end
