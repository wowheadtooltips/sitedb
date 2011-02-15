class CreateTrackings < ActiveRecord::Migration
  def self.up
    create_table :trackings do |t|
      t.integer :siteid
      t.string :ip
      t.string :hostname
      t.datetime :visited

      t.timestamps
    end
  end

  def self.down
    drop_table :trackings
  end
end
