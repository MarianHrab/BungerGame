# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_15_135014) do
  create_table "action_cards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characteristics", force: :cascade do |t|
    t.integer "age"
    t.integer "height"
    t.integer "weight"
    t.string "health"
    t.string "phobia"
    t.string "hobby"
    t.string "character"
    t.string "luggage"
    t.text "additional_info"
    t.string "knowledge"
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_characteristics_on_player_id"
  end

  create_table "condition_cards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age"
    t.integer "height"
    t.integer "weight"
    t.string "health"
    t.string "phobia"
    t.string "hobby"
    t.string "character"
    t.string "luggage"
    t.string "additional_info"
    t.string "knowledge"
    t.integer "characteristic_id"
    t.boolean "characteristics_visible", default: false
    t.string "opened_characteristic"
    t.index ["characteristic_id"], name: "index_players_on_characteristic_id"
    t.index ["room_id"], name: "index_players_on_room_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "limit"
    t.boolean "game_started", default: false
    t.integer "turn_status", default: 0
    t.integer "voted_out_player_id"
    t.integer "status"
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.integer "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_votes_on_player_id"
  end

  add_foreign_key "characteristics", "players"
  add_foreign_key "players", "characteristics"
  add_foreign_key "players", "rooms"
  add_foreign_key "players", "users"
  add_foreign_key "rooms", "users", column: "owner_id"
  add_foreign_key "rooms", "users", column: "owner_id"
  add_foreign_key "votes", "players"
end
