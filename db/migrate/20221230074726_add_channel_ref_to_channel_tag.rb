class AddChannelRefToChannelTag < ActiveRecord::Migration[7.0]
  def change
    add_index :channel_tags, :channel_id
  end
end
