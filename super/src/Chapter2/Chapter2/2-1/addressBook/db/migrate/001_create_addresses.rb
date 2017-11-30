class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table(:addresses) do |table|
        table.column  :name , :string , :limit => 20 , :null => false
        table.column  :zipCode , :string, :limit => 7
        table.column  :address , :string ,:limit => 80 , :null => false
        table.column  :created_on , :timestamp , :null => false
        table.column  :updated_on , :timestamp , :null => false
    end
  end

  def self.down
      drop_table :addresses
  end
end
