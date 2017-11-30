class LongerContentField < ActiveRecord::Migration
  def self.up
    remove_column :pages, :content
    add_column :pages, :content, :text
  end

  def self.down
  end
end
