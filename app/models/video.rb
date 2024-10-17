class Video < ApplicationRecord
  belongs_to :users
  validates :title, :url, :thumbnail_url, presence: true
end