class PrivateKey < ActiveRecord::Base
  belongs_to :user
  belongs_to :export_tag
  before_create :create_new_key

  def create_new_key
    require 'digest/md5'
    md5 = Digest::MD5::new
    now = Time::now
    md5.update(now.to_s)
    md5.update(String(now.usec))
    md5.update(String(rand(0)))
    md5.update(String($$))
    md5.update('foobar')
    self.key = md5.hexdigest
  end
end
