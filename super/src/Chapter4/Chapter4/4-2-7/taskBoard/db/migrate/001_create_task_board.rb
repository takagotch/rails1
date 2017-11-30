class CreateTaskBoard < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.column(:content,  :text);
      t.column(:status, :string);
      t.column(:priority,:integer);
      t.column(:owner , :string);
      t.column(:created_on, :datetime);
      t.column(:updated_on, :datetime);
    end
  end

  def self.down
    drop_table :tasks
  end

end
