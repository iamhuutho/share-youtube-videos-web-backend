class UserVideoInteraction < ApplicationRecord
  belongs_to :user
  belongs_to :video
  validates :action, inclusion: { in: ['like', 'dislike'] }
end
