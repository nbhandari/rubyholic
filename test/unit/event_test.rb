require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  def setup
    @limit = 10
  end
  
  test "limit of 10" do
    all_events = Event.find(:all)    
    assert all_events.size > @limit 
    assert Event.find_all_events.size <= @limit 
  end
  
  test "sort by group" do
    all_events = Event.find(:all)
    all_events.each do |e|
      e.group = groups(:one)
      e.save
    end
    
    assert all_events.size > @limit 
    
    all_events[@limit].group = groups(:aaa)
    all_events[@limit].save
    
    sorted_events = Event.sort_by_group
    assert_not_nil sorted_events
    assert sorted_events.size <= 10
    assert_equal groups(:aaa).name, sorted_events[0].group.name
  end
  
  test "sort by location" do
    all_events = Event.find(:all)
    all_events.each do |e|
      e.location = locations(:two)
      e.save
    end
    
    assert all_events.size > @limit 
    
    all_events[@limit].location = locations(:one)
    all_events[@limit].save
    
    sorted_events = Event.sort_by_location
    assert_not_nil sorted_events
    assert sorted_events.size <= 10
    assert_equal locations(:one).name, sorted_events[0].location.name
  end
  
end
