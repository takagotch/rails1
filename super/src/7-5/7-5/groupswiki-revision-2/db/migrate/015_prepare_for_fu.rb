class PrepareForFu < ActiveRecord::Migration
  def self.up
    drop_table :attachments
    
    create_table :attachments do |t|
      t.column :parent_id,  :integer
      t.column :content_type, :string
      t.column :filename, :string    
      t.column :thumbnail, :string 
      t.column :size, :integer
      t.column :width, :integer
      t.column :height, :integer
    end    
  end

  def self.down
  end
end
