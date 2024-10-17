class Video < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :description, presence: true
  validates :url, presence: true
  validates :thumbnail_url, presence: true
end