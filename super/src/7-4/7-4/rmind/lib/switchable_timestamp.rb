
module SwitchableTimestamp
  def self.included(base) #:nodoc:
    super
    base.alias_method_chain :create, :timestamps2
    base.alias_method_chain :update, :timestamps2
  end

  attr_accessor :use_record_timestamps

  def initialize(*args)
    self.use_record_timestamps = true
    super(*args)
  end

  def create_with_timestamps2 #:nodoc:
    if use_record_timestamps
      t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
      write_attribute('created_at', t) if respond_to?(:created_at) && created_at.nil?
      write_attribute('created_on', t) if respond_to?(:created_on) && created_on.nil?

      write_attribute('updated_at', t) if respond_to?(:updated_at)
      write_attribute('updated_on', t) if respond_to?(:updated_on)
    end
    create_without_timestamps2
  end

  def update_with_timestamps2 #:nodoc:
    if use_record_timestamps
      t = self.class.default_timezone == :utc ? Time.now.utc : Time.now
      write_attribute('updated_at', t) if respond_to?(:updated_at)
      write_attribute('updated_on', t) if respond_to?(:updated_on)
    end
    update_without_timestamps2
  end
end

