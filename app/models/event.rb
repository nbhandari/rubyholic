class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :location
  @limit = 10
  
  def self.find_all_events
    find(:all)[0, @limit]
  end
  
  def self.sort_by_group
    events = find(:all)
    events = events.sort{ |e1, e2| e1.group.name <=> e2.group.name }
    events[0,@limit]
  end
  
  def self.sort_by_location
    events = find(:all)
    events = events.sort{ |e1, e2| e1.location.name <=> e2.location.name }
    events[0,@limit]
  end
  
  def self.all_groups_collection
    Group.find(:all).collect {|grp| [ grp.name, grp.id ] }
  end  
  
  def self.all_locations_collection
    Location.find(:all).collect {|loc| [ loc.name, loc.id ] }
  end
  
      
end
