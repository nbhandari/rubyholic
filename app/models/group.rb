class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events
  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  @@limit = 10
  
  def self.find_groups
    find(:all, :limit => @@limit)
  end
  
  def self.sort_by_group_name
    find(:all, :order => :name, :limit => @@limit)
  end

  def self.sort_by_location_name
    find(:all, 
          :joins => "as grps INNER JOIN events as evts on grps.id = evts.group_id INNER JOIN locations as locs on evts.location_id = locs.id", 
          :order => 'locs.name, grps.name', 
          :select => "DISTINCT grps.*", 
          :limit => @@limit)
  end
  
end