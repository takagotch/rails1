class Address < ActiveRecord::Base
  has_one :userDetail
  has_many :mails
  validates_presence_of :address, :message => "No Input data(address)."
  validates_length_of :address,:maximum => 40,:too_long => "Input data too long.limit %d."
  validates_presence_of :zipCode, :message => "No Input data(zipCode)."
  validates_length_of :zipCode,:maximum => 7,:too_long => "Input data too long.limit %d.(EX:1234567)"
  def validate
    errors.add(:name, "No Input data(Name).") if name.blank?
    
  end
end
