# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      CREATE TYPE user_role AS ENUM ('patient', 'student', 'teacher', 'administrator');
    SQL

    create_table :users do |t|
      t.string :email,     null: false
      t.string :username,  null: false
      t.string :full_name, null: false
      t.string :provider
      t.string :uid, :string
      t.column :role, :user_role

      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
  end
end
