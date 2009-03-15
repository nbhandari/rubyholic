class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events
  
  validates_presence_of :name, :description
  validates_uniqueness_of :name

  acts_as_mappable  :through => :locations                    

  @@per_page = 10
  @@distance_radius = 10
  
  def self.find_groups page_num
    #~ find(:all, :limit => @@per_page)
    paginate(:all, :page => page_num, :per_page => @@per_page)
  end
  
  def self.sort_by_group_name page_num
    #~ find(:all, :order => :name, :limit => @@per_page)
    paginate(:all, :order => :name, :page => page_num, :per_page => @@per_page)
  end

  def self.sort_by_location_name page_num
    paginate(:all, 
          :joins => "INNER JOIN events as evts on groups.id = evts.group_id INNER JOIN locations on evts.location_id = locations.id", 
          :order => 'locations.name, groups.name', 
          :select => "DISTINCT groups.*", 
          :page => page_num,
          :per_page => @@per_page)

    #~ find(:all, 
          #~ :joins => "INNER JOIN events as evts on groups.id = evts.group_id INNER JOIN locations on evts.location_id = locations.id", 
          #~ :order => 'locations.name, groups.name', 
          #~ :select => "DISTINCT groups.*", 
          #~ :limit => @@per_page)
  end
  
  def self.sort_by_location_distance latlong, page_num
    paginate(:all, 
          :joins => "INNER JOIN events as evts on groups.id = evts.group_id INNER JOIN locations on evts.location_id = locations.id", 
          :order => 'distance', 
          :select => "DISTINCT groups.*", 
          :origin => latlong,
          :within => @@distance_radius,
          :page => page_num,
          :per_page => @@per_page)
    #~ find(:all, 
          #~ :joins => "INNER JOIN events as evts on groups.id = evts.group_id INNER JOIN locations on evts.location_id = locations.id", 
          #~ :order => 'distance', 
          #~ :select => "DISTINCT groups.*", 
          #~ :origin => latlong,
          #~ :within => @@distance_radius,
          #~ :limit => @@per_page)
  end
        
end