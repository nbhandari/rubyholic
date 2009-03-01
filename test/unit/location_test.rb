require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test "location validates presence of name" do
    location = Location.new
    assert !location.valid?
    assert location.errors.on(:name)
  end
  
  test "location validates presence of latitude" do
    location = Location.new
    assert !location.valid?
    assert location.errors.on(:latitude)
  end
  
  test "location validates presence of longitude" do
    location = Location.new
    assert !location.valid?
    assert location.errors.on(:longitude)
  end
    
end
