class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events
  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  def self.find_all_groups
    find(:all, :order => :name)
  end

end