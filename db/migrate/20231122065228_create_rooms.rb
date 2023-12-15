class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.references :owner, foreign_key: { to_table: :users }
      t.integer :turn_status, default: 0, null: false
      t.text :current_turn_data
      t.integer :limit
      t.boolean :game_started, default: false
      t.timestamps
    end

    # Додаємо enum 'turn_status' до таблиці 'rooms'
    change_table :rooms do |t|
      t.enum :turn_status, enum_name: 'turn_status', default: 'waiting_for_characteristic', null: false
    end
  end
end
