class AddVotedOutPlayerIdToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :voted_out_player_id, :integer
  end
end
