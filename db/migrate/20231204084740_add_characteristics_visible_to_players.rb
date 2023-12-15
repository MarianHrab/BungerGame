class AddCharacteristicsVisibleToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :characteristics_visible, :boolean, default: false
  end
end
