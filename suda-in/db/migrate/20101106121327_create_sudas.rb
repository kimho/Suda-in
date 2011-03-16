class CreateSudas < ActiveRecord::Migration
  def self.up
    create_table :sudas do |t|
      t.integer :user_id, :null => false
      t.string :message, :null => false
      t.string :agent, :null => false
      t.datetime :created_at, :null => false
    end
  end

  def self.down
    drop_table :sudas
  end
end
