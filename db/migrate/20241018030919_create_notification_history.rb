class CreateNotificationHistory < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_histories do |t|
      t.references :notification, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :read, default: false

      t.timestamps
    end

    add_index :notification_histories, [:notification_id, :user_id], unique: true, name: 'index_on_notification_and_user'
  end
end
