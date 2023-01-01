class CreateChannelTags < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_tags do |t|
      t.integer :channel_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
