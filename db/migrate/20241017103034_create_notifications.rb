class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :message
      t.references :user, null: false, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end
