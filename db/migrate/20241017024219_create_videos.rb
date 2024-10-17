class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :thumbnail_url
      t.string :url
      t.string :video_id
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
