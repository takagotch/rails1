class Page < ActiveRecord::Base
  require 'rexml/document'

  acts_as_versioned :table_name => 'page_versions'
  belongs_to :wiki
  belongs_to :user

  validates_presence_of :wiki, :path, :name
  before_validation :set_name

  after_save :update_wiki_name
#  after_save :add_user_to_wiki

  def add_user_to_wiki
    if !wiki.users.include? user
      wiki.users << user
    end
  end

  def update_wiki_name
    if path=='index'
      wiki.update_attributes! :name => name
    end
  end
  
  def self.path_from_string(string)
    string.gsub(/<.+?>/,'').gsub(/&.+?;/,' ').gsub(/\s+/,' ').tr('~!@#$%^&*()_+`-={}|[]\;\':",./<>?', ' ').tr(' ', '_').downcase.strip;
  end

  def related_pages
    return [] if path == 'index'
    
    wiki.pages.find(
      :all,
      :conditions => ['content LIKE ?', "%href='#{self.path}'%"]
    ).reject do |p|
      p == self
    end
  end
  
  def set_name
    if name.nil?
      write_attribute 'name', path.humanize
    end
  end
  
  def to_param
    self.path
  end
  
  def self.lily
    Page.find_by_path('lily_allen').destroy
    
    Page.create(
      :content => Mediawiki.convert_to_html(LILY_ALLEN),
      :name => 'Lily Allen',
      :path => 'lily_allen',
      :wiki_id => 1
    )
  end
  
  def tidy_and_whitelist(html)
    xhtml = Tidy.open(:show_warnings=>false) do |tidy|
      tidy.options.output_xml = true
      tidy.options.input_encoding = 'utf8'
      tidy.options.drop_empty_paras = true
      tidy.options.numeric_entities = true
      tidy.clean(html)
    end
    
    puts xhtml

    xhtml.gsub! /^.+?<body>/m, ''
    xhtml.gsub! /<\/body>.+/m, ''
    xhtml.strip!
    
    WhiteListHelper.tags.merge %w(center ul li table td th tbody tr)
      
    white_list(xhtml).strip
  end
  
  def content=(v)
    write_attribute 'content', tidy_and_whitelist(v)
  end
end
