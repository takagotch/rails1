require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  use_all_fixtures
  
  def test_permissions
    assert_equal [wikis(:groupswiki).id, wikis(:cars).id], users(:ben).wikis.collect(&:id)
    assert_equal [wikis(:cars).id], users(:pedro).wikis.collect(&:id)
  end

  def test_owned
    assert_equal [wikis(:groupswiki).id, wikis(:horses).id], users(:ben).owned_wikis.collect(&:id)
    assert_equal [wikis(:cars).id], users(:pedro).owned_wikis.collect(&:id)
  end

end
