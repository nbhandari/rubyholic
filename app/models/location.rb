class Location < ActiveRecord::Base
  has_many :events
  has_many :groups, :through => :events
  validates_presence_of :name, :latitude, :longitude
end
