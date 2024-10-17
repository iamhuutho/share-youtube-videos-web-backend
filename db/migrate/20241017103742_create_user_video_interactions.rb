class CreateUserVideoInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_video_interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.string :action

      t.timestamps
    end
  end
end
