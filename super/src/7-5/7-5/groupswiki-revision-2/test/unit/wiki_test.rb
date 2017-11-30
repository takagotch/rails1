require File.dirname(__FILE__) + '/../test_helper'

class WikiTest < Test::Unit::TestCase
  use_all_fixtures
  
  def test_create
    wiki = Wiki.create(
      :domain => 'zingblah.groupswiki.com',
      :user_id => users(:ben).id
    )
    
    assert_equal 1, wiki.pages.length

    assert_equal 'zingblah', wiki.name
    assert_equal 'zingblah', wiki.index_page.name
    assert users(:ben).can_view?(wiki)
    assert users(:ben).can_edit?(wiki)
    assert users(:ben).is_owner_of?(wiki)
  end

  def test_uri
    assert_equal 'http://horses.groupswiki.com/', wikis(:horses).uri
  end

  def test_create_private_wiki_for_user
    user = User.create(
      :name => 'fnolan',
      :email => 'frances@gmail.com',
      :password => 'passsword',
      :password_confirmation => 'passsword'
    )
    
    assert user.id
    
    wiki = Wiki.create_private_wiki_for_user(
      user
    )
    
    assert_equal 'fnolan-private.groupswiki.com', wiki.domain
    assert_equal 'fnolans private wiki', wiki.name
    
    assert_equal user.private_wiki, wiki
    assert_equal 1, user.owned_wikis.length
    assert user.can_view?(wiki)
    assert user.can_edit?(wiki)
    assert user.is_owner_of?(wiki)
  end
end
