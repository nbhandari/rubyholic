class AddGroupNameAndLocationNameToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :group_name, :string
    add_column :events, :location_name, :string
  end

  def self.down
    remove_column :events, :location_name
    remove_column :events, :group_name
  end
end
