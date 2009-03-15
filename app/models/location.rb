class Location < ActiveRecord::Base
  validates_presence_of :name, :address
  
  acts_as_mappable  :auto_geocode     => true,                    
                            :lat_column_name  => 'latitude',                    
                            :lng_column_name  => 'longitude'
                          
  has_many :events
  has_many :groups, :through => :events
  
end
