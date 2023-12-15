class AddOpenedCharacteristicToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :opened_characteristic, :string
  end
end
