class Notification < ApplicationRecord
  belongs_to :user
  has_many :notification_history
  validates :title, presence: true
  validates :message, presence: true
end
