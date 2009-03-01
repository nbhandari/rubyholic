class AddLatitudeLongitudeToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :latitude, :float
    add_column :locations, :longitude, :float
  end

  def self.down
    remove_column :locations, :longitude
    remove_column :locations, :latitude
  end
end
