class AddTwittedToSudas < ActiveRecord::Migration
  def self.up
    add_column :sudas, :twitted, :boolean
  end

  def self.down
    remove_column :sudas, :twitted
  end
end
