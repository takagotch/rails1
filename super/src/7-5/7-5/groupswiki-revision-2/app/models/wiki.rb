class Wiki < ActiveRecord::Base
  has_many :pages
  has_and_belongs_to_many :users, :join_table => :permissions
  has_many :revisions
  validates_uniqueness_of :domain
  validates_format_of :email, :with => /^\S+@\S+\.\S+$/
  after_create :create_index_page
  

  def validate
    if accepted != true
      errors.add :accepted, 'You must accept the terms and conditions'
    end
  end
  
  def domain=(st)
    write_attribute 'domain', st.downcase.strip.gsub(/[^a-z0-9]/, '') + '.groupswiki.com'
  end
  
  def index_page
    pages.find_by_path('index')
  end
  
  def create_blank_page(path)
    pages.create(:path => path)
  end
  
  def create_index_page
    Page.create(
      :name => name,
      :path => 'index',
      :wiki_id => id
    )
  end
end