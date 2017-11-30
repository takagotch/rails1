require 'digest/sha2'

class User < ActiveRecord::Base
  include DashBoard
  self.record_timestamps = false
  include SwitchableTimestamp

  has_many :tasks, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_one  :root_project,
           :class_name => "Project",
           :conditions => 'projects.parent_project_id is null'
  has_many :tags, :dependent => :destroy
  has_many :taggings

  validates_uniqueness_of :login
  attr_reader :password
  validates_confirmation_of :password
  validates_presence_of :login, :email

  def initial_setup
    Project.create!(:user=>self, :name=>'root', :created_at=>created_at, :updated_at=>created_at, :locked=>true, :review_interval=>1)
  end

  def destroy
    reload
    if root_project
      root_project.locked = false
      root_project.save!
    end
    super
  end

  def password=(pass)
    @password = pass
    salt = [Array.new(6) {rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash =
      salt, User.hexdigest(pass, salt)
  end

  def self.authenticate(login, pass)
    user = User.find(:first, :conditions => ['login = ? ', login])
    if user.blank? or
        hexdigest(pass, user.password_salt) != user.password_hash
      raise AuthenticationError
    end
    user
  end

  def self.hexdigest(pass, salt)
    Digest::SHA256.hexdigest(pass + salt)
  end

  def with_myscope(&block)
    Project.with_scope({
                         :find   => {
                           :conditions => ["projects.user_id = ?", self.id]
                         },
                         :create => { :user_id  => self.id},
                       }) do
      Task.with_scope({
                        :find   => {
                          :conditions => ["tasks.user_id = ?", self.id]
                        },
                        :create => { :user_id  => self.id},
                      }) do
        Tag.with_scope({
                         :find   => {
                           :conditions => ["tags.user_id = ?", self.id]
                         },
                         :create => { :user_id  => self.id},
                       }) do
          Tagging.with_scope({
                              :find   => {
                                :conditions => ["taggings.user_id = ?", self.id]
                              },
                              :create => { :user_id  => self.id},
                            }) do
            block.call
          end
        end
      end
    end
  end

  def find_tag(name)
    tags.find(:first, :conditions=>['name = ?', name])
  end

  has_many :commands, :dependent => :destroy, :extend=>CommandProxy

  def last_command
    commands.last_command
  end


  def to_yaml_obj
    tags = self.tags.sort.collect do |t|
      t.to_yaml_obj
    end
    projects = self.projects.collect do |p|
      p.to_yaml_obj
    end.find_all { |x| not x.nil? }
    {
      :login => login,
      :email => email,
      :firstname => firstname,
      :lastname => lastname,
      :tags => tags,
      :projects => projects,
      :created_at => created_at,
      :updated_at => updated_at,
      :ver => "1.0"
    }
  end

  def to_yaml
    to_yaml_obj.to_yaml
  end

  def self.load_yaml_obj(obj, login=nil)
    u = {
      :login => (login or obj[:login]),
      :email => obj[:email],
      :firstname => obj[:firstname],
      :lastname => obj[:lastname],
      :created_at => obj[:created_at],
      :updated_at => obj[:updated_at],
      :use_record_timestamps => false
    }

    user = self.create!(u)

    obj[:tags].each do |tag|
      Tag.load_yaml_obj(user, tag)
    end

    obj[:projects].each do |pd|
      Project.load_yaml_obj(user, pd)
    end
    user.use_record_timestamps = true

    user
  end

  def self.load_yaml(yaml, login=nil)
    data = YAML::load(yaml)
    load_yaml_obj(data, login)
  end

  def self.save_all
    dir = $rmind_config[:save_dir]
    User.find(:all).each do |u|
      File::open(File::join(dir, u.login), "w") do |f|
        f.puts u.to_yaml
      end
    end
  end

  class AuthenticationError < RuntimeError
  end
end
