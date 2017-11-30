class AddAcceptanceToWikis < ActiveRecord::Migration
  def self.up
    add_column 'wikis', 'accepted', :boolean
  end

  def self.down
    remove_column 'wikis', 'accepted'
  end
end
