class ApplicationController < ActionController::API
  before_action :authenticate_user!
  before_action :check_rate_limit!

  attr_reader :current_user

  private

  def authenticate_user!
    api_key = request.headers['X-API-KEY']
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless api_key

    user = User.find_by(api_key: api_key)
    if user&.active_key?
      @current_user = user
    else
      render json: { error: 'Invalid or expired API key' }, status: :unauthorized
    end
  end

  def check_rate_limit!
    limiter = RateLimiterService.new(@current_user)
    unless limiter.allowed?
      render json: { error: 'Rate limit exceeded. Try later.' }, status: :too_many_requests
    end
  end
end
