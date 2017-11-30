class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.column "user_id", :integer, :null=>false
      t.column "delegation_tag_id", :integer, :null=>false
      t.column "email", :string, :limit => 60
      t.column "tel1", :string, :limit => 30
      t.column "tel2", :string, :limit => 30
      t.column "memo", :string
      t.column "skype", :string
      t.column "mixi", :string
      t.column "twitter", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index :addresses, [:user_id, :delegation_tag_id]
  end

  def self.down
    remove_index :addresses, [:user_id, :delegation_tag_id]
    drop_table :addresses
  end
end
