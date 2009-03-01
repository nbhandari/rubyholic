class DropLatitudeLongitudeFromLocation < ActiveRecord::Migration
  def self.up
    remove_column :locations, :latitude
    remove_column :locations, :longitude
  end

  def self.down
    add_column :locations, :latitude, :string
    add_column :locations, :longitude, :string
  end
end
