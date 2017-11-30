class AddPasswords < ActiveRecord::Migration
  def self.up
    add_column :wikis, :password, :string
    add_column :wikis, :public_password, :string
  end

  def self.down
  end
end
