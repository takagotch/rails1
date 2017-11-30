class AddCssToWikis < ActiveRecord::Migration
  def self.up
    add_column :wikis, :css, :text
    add_column :wikis, :classes, :text
    add_column :wikis, :header, :text
    add_column :wikis, :footer, :text
  end

  def self.down
  end
end
