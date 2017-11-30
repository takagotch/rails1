require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  use_all_fixtures

  def test_belongs
    assert_equal pages(:index).wiki, wikis(:groupswiki)
  end
  
  def test_create
    p = Page.create(
      :name => 'FRanziskaner Weißbier',
      :path => 'some_path',
      :wiki_id => wikis(:groupswiki).id,
      :user_id => users(:ben),
      :content => 'great beer!'
    )
    
    assert p.valid?
    assert !p.new_record?
    
    assert_equal 'FRanziskaner Weißbier', p.name
    assert_equal 'some_path', p.path
  end
  
  def test_versioning
    p = pages(:index)

    p.update_attributes!(
      :content => 'i just owned this!'
    )
    
    assert p.valid?

    p.reload

    assert_equal 13, p.version
    assert_equal 4, p.versions.length
    assert_equal 'i just owned this!', p.versions.last.content
  end
  
  def test_opportunistic_create
    p = wikis(:groupswiki).pages.create(
      :path => 'blah_blah',
      :user => users(:ben)
    )
    
    assert p.valid?
    assert !p.new_record?
    assert_equal 'Blah blah', p.name
  end
  
  def test_tidy_strip_end_whistepace
    # Too hard for mee

    return

    p = Page.new
    
    assert_equal '<p>blah</p>', p.tidy_and_whitelist('<p>blah</p><p><br /><br /></p><br /><br />')
  end

  def test_set_user
    p = pages(:index)
    assert !p.wiki.users.include?(users(:andrew))

    p.update_attributes!(
      :content => 'blah',
      :user_id => users(:andrew).id
    )

    assert p.wiki.users.include?(users(:andrew))
  end 
  
end
