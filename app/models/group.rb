class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events
  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  
  #~ def self.sort_by_group_name
    #~ find(:all, :order => :name, :limit => @limit)
  #~ end
  
  #~ def self.sort_by_location_name
    #~ find(:all, :include => [:events => :location], :order => 'locations.name, groups.name', :limit => @limit)
  #~ end
  
end