class AddVotesCountToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :votes_count, :integer
  end
end
