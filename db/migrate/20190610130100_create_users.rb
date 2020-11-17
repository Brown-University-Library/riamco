# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration[4.2]
    def self.up
      options = nil
      if ENV['DATABASE_ADAPTER'] == "mysql2"
        options = 'DEFAULT CHARSET=utf8'
      end
      create_table(:users, :options => options) do |t|
        t.string :username, limit: 20
        t.string :password, limit: 100
        t.string :description, limit: 50
        t.string :fileprefix, limit: 20
        t.string :role, limit: 20
        t.timestamps
      end

      add_index :users, :username
    end

    def self.down
      drop_table :users
    end
  end
