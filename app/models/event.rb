class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :location
  @@limit = 10
  
  def self.find_all_events
    find(:all, :limit => @@limit)
  end
  
  def self.sort_by_group
    find(:all, :include => :group, :order => 'groups.name', :limit => @@limit)
  end
  
  def self.sort_by_location
    events = find(:all, :include => :location, :order => 'locations.name', :limit => @@limit)
  end
  
  def self.all_groups_collection
    Group.find(:all).collect {|grp| [ grp.name, grp.id ] }
  end  
  
  def self.all_locations_collection
    Location.find(:all).collect {|loc| [ loc.name, loc.id ] }
  end
  
      
end
