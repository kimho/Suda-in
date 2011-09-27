class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :suda_id
      t.integer :user_id
      t.text :message
      t.datetime :create_at

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
