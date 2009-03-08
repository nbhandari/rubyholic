require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  
  def setup
    @limit = 10
  end
  
  test "group validates presence of name" do
    group = Group.new
    assert !group.valid?
    assert group.errors.on(:name)
  end
  
  test "group validates presence of description" do
    group = Group.new
    assert !group.valid?
    assert group.errors.on(:description)
  end
  
  test "group names are unique" do
    group = Group.new(groups(:one).attributes)
    assert !group.valid?
    assert group.errors.on(:name)
  end

end
