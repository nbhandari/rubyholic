class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events
  
  validates_presence_of :name, :description
  validates_uniqueness_of :name

  acts_as_mappable  :through => :locations                    

  @@limit = 10
  @@distance_radius = 10
  
  def self.find_groups
    find(:all, :limit => @@limit)
  end
  
  def self.sort_by_group_name
    find(:all, :order => :name, :limit => @@limit)
  end

  def self.sort_by_location_name
    find(:all, 
          :joins => "INNER JOIN events as evts on groups.id = evts.group_id INNER JOIN locations on evts.location_id = locations.id", 
          :order => 'locations.name, groups.name', 
          :select => "DISTINCT groups.*", 
          :limit => @@limit)
  end
  
  def self.sort_by_location_distance latlong
    find(:all, 
          :joins => "INNER JOIN events as evts on groups.id = evts.group_id INNER JOIN locations on evts.location_id = locations.id", 
          :order => 'distance', 
          :select => "DISTINCT groups.*", 
          :origin => latlong,
          :within => @@distance_radius,
          :limit => @@limit)
  end
        
end