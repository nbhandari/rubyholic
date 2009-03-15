require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  
  def setup
    @loc_name = 'Office'
    @loc_addr = '333 108th Ave NE, Bellevue, WA'
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'location[address]'
    }
  end

  test "should create location" do
    assert_difference('Location.count') do
      post :create, :location => { 
        :name => @loc_name ,
        :address => @loc_addr
      }
    end

    assert_redirected_to location_path(assigns(:location))
  end

  test "should show location" do
    get :show, :id => locations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => locations(:one).id
    assert_tag :tag => 'input', :attributes => {
      :name => 'location[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'location[address]'
    }
    assert_response :success
  end

  test "should update location" do
    put :update, :id => locations(:one).id, :location => { 
      :name => 'Updated Location'
    }
    assert_redirected_to location_path(assigns(:location))
    
    assert_equal 'Updated Location', Location.find(locations(:one).id).name
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => locations(:one).id
    end

    assert_redirected_to locations_path
  end
  
  test "should error on name" do
    assert_difference('Location.count', 0) do
      post :create, :location => {
        #~ :name => @loc_name ,
        :address => @loc_addr
      }
    end
    
    assert location = assigns(:location)
    assert !location.valid?
    location.errors.on(:name)
    
    assert_match(/Name can\'t be blank/, @response.body)
  end
  
  test "should error on address" do
    assert_difference('Location.count', 0) do
      post :create, :location => {
        :name => @loc_name
        #~ :address => @loc_addr
      }
    end
    
    assert location = assigns(:location)
    assert !location.valid?
    location.errors.on(:address)
    
    assert_match(/Address could not locate address/, @response.body)
  end


  #~ test "should error on latitude" do
    #~ assert_difference('Location.count', 0) do
      #~ post :create, :location => {
        #~ :name => 'My loc',
        #~ :longitude => '100W'
      #~ }
    #~ end
    
    #~ assert location = assigns(:location)
    #~ assert !location.valid?
    #~ location.errors.on(:latitude)
    
    #~ assert_match(/Latitude can\'t be blank/, @response.body)
  #~ end
  
  #~ test "should error on longitude" do
    #~ assert_difference('Location.count', 0) do
      #~ post :create, :location => {
        #~ :name => 'My loc',
        #~ :latitude => '60N',
        #~ :longitude => '100W'
      #~ }
    #~ end
    
    #~ assert location = assigns(:location)
    #~ assert !location.valid?
    #~ location.errors.on(:longitude)
    
    #~ assert_match(/Longitude can\'t be blank/, @response.body)
  #~ end

end
