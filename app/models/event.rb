class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :location
  
  def self.find_all_events
    find(:all)
  end
  
  def self.sort_by_group
    events = find(:all)
    events = events.sort{ |e1, e2| e1.group.name <=> e2.group.name }
  end
  
  def self.sort_by_location
    events = find(:all)
    events = events.sort{ |e1, e2| e1.location.name <=> e2.location.name }
  end
  
  def group_names
    #~ Group.find(:all)
  end
    
end
