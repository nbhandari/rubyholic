require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  
  def setup
    all_events = Event.find(:all)
    all_events.each do |e|
      e.group = groups(:one)
      e.location = locations(:one)
      e.save
    end
  end

  test "index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end
  
  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'event[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'event[description]'
    }
    assert_tag :tag => 'select', :attributes => {
      :name => 'event[group_id]'
    }
    
    assert_select "#event_group_id" do
      Group.find(:all).each do |grp|
        assert_select "option",  grp.name
      end
    end
    
    assert_select "#event_location_id" do
      Location.find(:all).each do |loc|
        assert_select "option",  loc.name
      end
    end  
  end
  
  test "should create event" do
    assert_difference('Event.count') do
      post :create, :event => { 
        :name => 'New event',
        :description => 'My event description',
        :start_date => Time.now,
        :end_date=> Time.now + 24*3600,
        #~ :group_name => groups(:one),
        :group_id => groups(:one).id,
        #~ :location_name => locations(:one)
        :location_id => locations(:one).id
      }
    end
    assert_redirected_to :action => :index
  end
  
end
