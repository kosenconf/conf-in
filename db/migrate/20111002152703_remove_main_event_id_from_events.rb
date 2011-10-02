class RemoveMainEventIdFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :main_event_id
  end

  def down
    add_column :events, :main_event_id, :integer
  end
end
