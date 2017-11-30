class Schedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule_tagging
  def user_attributes
    self.class.columns.collect do |col|
      col.name.intern
    end - [:id, :user_id, :delegation_tag_id, :created_at, :updated_at]
  end
end
