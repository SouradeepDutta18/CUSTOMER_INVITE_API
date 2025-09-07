class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :api_key, presence: true, uniqueness: true
  validates :name, presence: true

  # Check if API key is active
  def active_key?
    expires_at.future?
  end
end
