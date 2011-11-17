class RemovePlaceRoomFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :place_room
  end

  def down
    add_column :events, :place_room, :string
  end
end
