class User < ActiveRecord::Base
  has_many :owned_wikis, :class_name => 'Wiki', :order => 'ID'
  has_and_belongs_to_many :wikis, :join_table => :permissions
  require 'digest'
  
  validates_presence_of :password, :email, :name
  validates_uniqueness_of :email, :name
  validates_format_of :email, :with => /\S+@\S+\.\S{2,}/, :message => ' must contain and @ and a .'
  validates_format_of :name, :with => /^[0-9a-z_]+$/, :message => ' can only contain letters, numbers and the underscore'
  
  def private_wiki
    owned_wikis.first
  end
  
  def password_confirmation; end
  
  def password_confirmation=(v)
    @password_confirmation = v
  end
  
  def name=(name)
    write_attribute :name, name.downcase
  end

  def validate
    if (new_record?) and (@password_confirmation != password)
      errors.add :password_confirmation, ' is not correct'
    end
  end
  
  def can_view?(obj)
    return nil if obj.class != Wiki
    
    obj.users.include? self
  end
    
  def can_edit?(obj)
    return nil if obj.class != Wiki
    
    true
    #obj.users.include? self
  end
    
  def is_owner_of?(obj)
    return nil if obj.class != Wiki
    
    self.owned_wikis.include? obj
  end

  def self.find_by_remember_me_cookie(cookie)
    id, key = cookie.split /!/
    
    user = User.find_by_id(id)

    if (user) and (user.remember_me_key == key)
      return user
    else
      return nil
    end
  end
  
  def remember_me_cookie
    "#{id}!#{remember_me_key}"
  end
  
  def remember_me_key
    Digest::MD5.hexdigest "--MMM--SALTYDOG!--#{id}--"
  end
    
  def to_param
    name
  end
  
end
