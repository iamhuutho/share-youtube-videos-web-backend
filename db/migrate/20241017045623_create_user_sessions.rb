class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_token, null: false
      t.datetime :expires_at, null: false
      t.boolean :revoked, default: false
      
      t.timestamps
    end

    add_index :user_sessions, :session_token, unique: true
  end
end
