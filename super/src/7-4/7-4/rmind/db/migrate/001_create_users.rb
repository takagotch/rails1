class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column "login", :string, :limit => 80, :default => "", :null => false
      t.column "email", :string, :limit => 60, :default => "", :null => false
      t.column "firstname", :string, :limit => 40
      t.column "lastname", :string, :limit => 40
      t.column "password_salt", :string
      t.column "password_hash", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
