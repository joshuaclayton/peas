class CreatePeas < ActiveRecord::Migration
  def self.up
    create_table :peas do |table|
      table.string :long_url, :key
      table.timestamps
    end

    change_table :peas do |table|
      table.index :long_url
      table.index :key
    end
  end

  def self.down
    drop_table :peas
  end
end
