# The "users" table was left over from a login feature (Devise) that the site no
# longer has. It is empty in production (0 rows) and nothing in the app uses it.
class DropUnusedUsersTable < ActiveRecord::Migration[8.1]
  def up
    raise "users table is not empty - not dropping it" if table_exists?(:users) && select_value("SELECT COUNT(*) FROM users").to_i > 0
    drop_table :users, if_exists: true
  end

  def down
    create_table :users, id: :serial do |t|
      t.string :email, limit: 255, default: "", null: false
      t.string :encrypted_password, limit: 255, default: "", null: false
      t.string :reset_password_token, limit: 255
      t.datetime :reset_password_sent_at, precision: nil
      t.datetime :remember_created_at, precision: nil
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at, precision: nil
      t.datetime :last_sign_in_at, precision: nil
      t.string :current_sign_in_ip, limit: 255
      t.string :last_sign_in_ip, limit: 255
      t.datetime :created_at, precision: nil
      t.datetime :updated_at, precision: nil
    end
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
