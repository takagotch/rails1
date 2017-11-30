class Attachment < ActiveRecord::Base
  belongs_to :wiki
  has_attachment :content_type => :image, 
                  :storage => :file_system, 
                  :max_size => 2.megabytes,
                  :resize_to => '480x>',
                  :path_prefix => 'public/uploads'
end