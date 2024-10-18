class User < ApplicationRecord
  has_many :videos
  has_many :user_sessions
  has_many :user_video_interactions
  has_many :notification
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
