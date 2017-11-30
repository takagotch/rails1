class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :wiki_id, :integer
      t.column :file, :string
    end
  end

  def self.down
    drop_table :attachments
  end
end
