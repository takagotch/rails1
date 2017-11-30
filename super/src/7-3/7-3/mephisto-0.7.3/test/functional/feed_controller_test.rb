require File.dirname(__FILE__) + '/../test_helper'
require_dependency 'feed_controller'

# Re-raise errors caught by the controller.
class FeedController; def rescue_action(e) raise e end; end

class FeedControllerTest < Test::Unit::TestCase
  fixtures :contents, :sections, :assigned_sections, :sites
  
  def setup
    @controller = FeedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_feed_assigns
    get :feed, :sections => ['about']
    assert_equal sections(:about), assigns(:section)
    assert_equal [contents(:welcome), contents(:about), contents(:site_map)], assigns(:articles)
    assert_select 'feed>title', 'Mephisto - About'
    assert_atom_entries_size 3
  end
  
  def test_feed_comes_from_site
    host! 'cupcake.com'
    get :feed, :sections => ['about']
    assert_equal sections(:cupcake_about), assigns(:section)
    assert_equal [contents(:cupcake_welcome)], assigns(:articles)
    assert_atom_entries_size 1
  end
  
  def test_site_in_feed_links
    host! 'cupcake.com'
    get :feed, :sections => []
    assert_models_equal [sections(:cupcake_home)], [assigns(:section)]
    assert_models_equal [contents(:cupcake_welcome)], assigns(:articles)
    assert_atom_entries_size 1
    assert_tag 'link', :attributes => {:href => 'http://cupcake.com/'}
  end
  
  def test_should_return_record_not_found_for_bad_feed_urls
    assert_raise ActiveRecord::RecordNotFound do
      get :feed, :sections => %w(beastie boys)
    end
  end
  
  def test_should_find_comments_by_site
    get :feed, :sections => %w(all_comments.xml)
    assert_select 'feed>title', 'Mephisto - All Comments'
    assert_nil assigns(:section)
    assert_models_equal [contents(:welcome_comment)], assigns(:comments)
    assert_atom_entries_size 1
  end
  
  def test_should_find_comments_by_section
    get :feed, :sections => %w(comments.xml)
    assert_select 'feed>title', 'Mephisto - Home Comments'
    assert_models_equal [sections(:home)], [assigns(:section)]
    assert_models_equal [contents(:welcome_comment)], assigns(:comments)
    assert_atom_entries_size 1
  end
end

context "Home Section Feed" do
  fixtures :contents, :sections, :assigned_sections, :sites
  def setup
    @controller = FeedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    get :feed, :sections => []
    @contents = get_xpath '//entry/content'
  end
  
  specify "should show titles" do
    assert_xpath '/feed/entry[title="Welcome to Mephisto"]'
    assert_xpath '/feed/entry[title="Another Welcome to Mephisto"]'
  end
  
  specify "show absolute urls" do
    assert_select 'feed entry link' do
      assert_select '[href=?]', /^http\:\/\/test\.host\/\d{4}\/.*$/
    end
  end

  specify "show absolute urls with custom relative url root" do
    begin
      old_root = ActionController::AbstractRequest.relative_url_root
      ActionController::AbstractRequest.relative_url_root = '/weblog'
      get :feed, :sections => []
      assert_select 'feed entry link' do
        assert_select '[href=?]', /^http\:\/\/test\.host\/weblog\/\d{4}\/.*$/
      end
    ensure
      ActionController::AbstractRequest.relative_url_root = old_root
    end
  end

  specify "should not double escape html" do
    text = @contents.first.get_text.to_s.strip
    assert text.starts_with("welcome summary\n&lt;p&gt;quentin&#8217;s &#8220;welcome&#8221;"), "'#{text.inspect}' was double escaped"
  end
  
  specify "should sanitize content" do
    text = @contents.first.get_text.to_s.strip
    evil = "<script>hi</script><a onclick=\"foo\" href=\"#\">linkage</a></p>"
    good = "&lt;script>hi&lt;/script><a href='#'>linkage</a></p>"
    assert !text.ends_with(CGI::escapeHTML(evil)), "'#{text.inspect}' was not sanitized"
    assert  text.ends_with(CGI::escapeHTML(good)), "'#{text.inspect}' was not sanitized"
  end
end