class Video < ApplicationRecord
  belongs_to :user
  validates :title, :url, :thumbnail_url, presence: true
end