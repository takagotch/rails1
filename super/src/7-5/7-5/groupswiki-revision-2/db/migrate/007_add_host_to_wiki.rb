class AddHostToWiki < ActiveRecord::Migration
  def self.up
    add_column :wikis, :domain, :string
  end

  def self.down
    drop_column :wikis, :domain
  end
end
