class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do | table |
        table.column  :mailAddress , :string ,:limit => 80 ,:null => false
        table.column  :address_id , :integer , :null => false
    end
  end

  def self.down
    drop_table :mails
  end
end
