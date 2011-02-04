class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.integer :id
      t.string :uri
      t.string :name
      t.string :region
      t.string :realm
      t.string :faction
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
