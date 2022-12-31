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

ActiveRecord::Schema[7.0].define(version: 2022_12_31_090753) do
  create_table "channel_games", force: :cascade do |t|
    t.integer "game_id"
    t.integer "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_channel_games_on_channel_id"
  end

  create_table "channel_statuses", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "status_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_channel_statuses_on_channel_id"
  end

  create_table "channel_tags", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_channel_tags_on_channel_id"
  end

  create_table "channels", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "stream_link"
    t.text "preview_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.text "about"
    t.integer "language_id"
    t.index ["user_id"], name: "index_channels_on_user_id"
  end

  create_table "preview_statuses", force: :cascade do |t|
    t.integer "channel_id"
    t.integer "status_id"
    t.datetime "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_preview_statuses_on_channel_id"
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

  add_foreign_key "channel_games", "channels"
end
