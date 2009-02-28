require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

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

end
