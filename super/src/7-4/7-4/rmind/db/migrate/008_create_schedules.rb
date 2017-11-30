class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.column "user_id", :integer, :null => false
      t.column "schedule_tagging_id", :integer, :null => false
      t.column "date", :date
      t.column "from", :datetime
      t.column "to", :datetime
      t.column "preparation", :integer, :default => 0, :null=>false
      t.column "place", :string, :limit => 255
      t.column "memo", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end

    add_index :schedules, [:user_id, :schedule_tagging_id]
  end

  def self.down
    remove_index :schedules, [:user_id, :schedule_tagging_id]
    drop_table :schedules
  end
end
