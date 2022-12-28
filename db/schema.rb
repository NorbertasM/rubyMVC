ActiveRecord::Schema[7.0].define(version: 2022_12_28_161006) do
  create_table "channels", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "stream_link"
    t.text "preview_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
