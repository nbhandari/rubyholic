require 'test_helper'
require 'flexmock/test_unit'

class GroupsControllerTest < ActionController::TestCase
  
  def setup
    @limit_num_grps = 10
  end
  

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
  end

  test "should create group" do
    assert_difference('Group.count') do
      post :create, :group => { 
        :name => 'New group',
        :description => 'My description'
      }
    end
    assert_redirected_to group_path(assigns(:group))
  end

  test "should show group" do
    get :show, :id => groups(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => groups(:one).id
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
    assert_response :success
  end

  test "should update group" do
    put :update, :id => groups(:one).id, :group => { 
    :name => 'Different name'
    }
    assert_redirected_to group_path(assigns(:group))
    assert_equal 'Different name', Group.find(groups(:one).id).name
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, :id => groups(:one).id
    end

    assert_redirected_to groups_path
  end
  
  test "should error on name missing" do
    assert_difference('Group.count', 0) do
      post :create, :group => {
        :description  => 'Group description',
      }
    end
    
    assert group = assigns(:group)
    assert !group.valid?
    group.errors.on(:name)
    
    assert_match(/Name can\'t be blank/, @response.body)
  end
  
  test "should error on description missing" do
    assert_difference('Group.count', 0) do
      post :create, :group => {
        :name  => 'Group name',
      }
    end
    
    assert group = assigns(:group)
    assert !group.valid?
    group.errors.on(:description)
    
    assert_match(/Description can\'t be blank/, @response.body)
  end

  test "should error on name duplicate" do
    assert_difference('Group.count', 0) do
      post :create, :group => {
        :name => groups(:one).name,
        :description  => 'Group description',
      }
    end
    
    assert group = assigns(:group)
    assert !group.valid?
    group.errors.on(:name)
    
    assert_match(/Name has already been taken/, @response.body)
  end
  
  
  test "should sort on group name" do
    get :sort_by_group_name
    grps_actual = assigns(:groups)
    
    all_grps = Group.find(:all)
    grps_expected = all_grps.sort {|g1, g2| g1.name <=> g2.name }
    grps_expected = grps_expected[0, @limit_num_grps]
    assert_equal grps_expected, grps_actual
  end
  
  test "should sort on location name" do
    #~ create the association of events with groups
    all_events = Event.find(:all)
      all_events.each do |e|
      e.group = groups(:aaa)
      e.location = locations(:two)
      e.save
    end
    
    #~ make one event use group 'zzz' (this should be last when sorted by group name), 
    #~ but set its location to 'one'. All other events use location of 'two'
    evt = events(:one)
    evt.group = groups(:zzz)
    evt.location = locations(:one)
    evt.save
    
    get :sort_by_location_name
    grps_actual = assigns(:groups)
    
    assert_equal groups(:zzz), grps_actual[0]
    assert grps_actual.size <= @limit_num_grps
  end
  
  test "limits number of groups displayed on index to 10" do
    all_grps = Group.find(:all)
    assert all_grps.size > @limit_num_grps
    
    get :index
    assert_response :success
    
    assert_tag :tag => 'a', :attributes => {
      :class => 'next_page',
      :href => '/groups?page=2'
    }
    
    displayed_grps = assigns(:groups)
    
    assert_not_nil displayed_grps
    assert displayed_grps.size > 0
    assert displayed_grps.size <= @limit_num_grps
  end
  
  test "pagination on groups" do
    all_grps = Group.find(:all)
    assert all_grps.size > @limit_num_grps
    
    get :index, :page => 2
    
    assert_response :success
    
    assert_tag :tag => 'a', :attributes => {
      :class => 'prev_page',
      :href => '/groups?page=1'
    }

    displayed_grps = assigns(:groups)
    
    assert_not_nil displayed_grps
    assert displayed_grps.size > 0
    assert displayed_grps.size <= @limit_num_grps
  end
  
  test "get index with IP address" do
    ip = '66.235.6.100'
 
    @request.env['REMOTE_HOST'] = ip
 
    flexmock(GeoIPClient).should_receive(:city).once.with(ip).and_return(
      [ "66.235.6.100",
        "66.235.6.100",
        "US",
        "USA",
        "United States",
        "NA",
        "WA",
        "Seattle",
        "98144",
        47.5839, -122.2995, 819, 206]
    )
    get :index
  end
  
  test "should sort on location distance" do
    #~ create the association of events with groups
    all_events = Event.find(:all)
      all_events.each do |e|
      e.group = groups(:aaa)
      e.location = locations(:one)
      e.save
    end
    
    #~ make one event use group 'two' 
    #~ set its location to 'two'. All other events use location of 'one'
    #~ location 'two' has the same lat-long as the user's IP. So this should show up when sorted by distance
    evt = events(:one)
    evt.group = groups(:two)
    evt.location = locations(:two)
    evt.save
    
    #~ Setup flexmock to return user's IP location as that of location two
    ip = '11.111.11.100'
 
    @request.env['REMOTE_HOST'] = ip
 
    flexmock(GeoIPClient).should_receive(:city).once.with(ip).and_return(
      [ "11.111.11.100",
        "11.111.11.100",
        "US",
        "USA",
        "United States",
        "NA",
        "WA",
        "Seattle",
        "98144",
        47.5839, -122.2995, 819, 206]
    )
    
    get :sort_by_location_distance
    grps_actual = assigns(:groups)
    
    assert_equal 1, grps_actual.size
    assert_equal groups(:two), grps_actual[0]
  end
  
end
