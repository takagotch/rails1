class CreateUserDetails < ActiveRecord::Migration
  def self.up
     create_table :user_details do | table |
        table.column  :profile , :text ,:null => false
        table.column  :telNum , :string, :limit => 14
        table.column  :address_id , :integer , :null => false
    end
  end

  def self.down
    drop_table :user_details
  end
end
