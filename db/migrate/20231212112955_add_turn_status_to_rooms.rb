class AddTurnStatusToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :turn_status, :integer, default: 0
  end
end
