class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :delegation_tag

  def self.user_attributes
    columns.collect do |col|
      col.name.intern
    end - [:id, :user_id, :delegation_tag_id, :created_at, :updated_at]
  end
end
