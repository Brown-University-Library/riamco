# -*- encoding : utf-8 -*-
class CreateOrganizations < ActiveRecord::Migration
  def self.up
    options = nil
    if Rails.env.production?
      options = 'DEFAULT CHARSET=utf8'
    end
    create_table(:organizations, :options => options) do |t|
      t.integer :organization_id
      t.string :name, limit: 255
      t.integer :active
      t.timestamps
    end

    add_index :organizations, :organization_id
    add_index :organizations, :name
  end

  def self.down
    drop_table :organizations
  end
end
