class Revision < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  set_table_name 'page_versions'
end
