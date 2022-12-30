class AddChannelRefToChannelStatuses < ActiveRecord::Migration[7.0]
  def change
    add_index :channel_statuses, :channel_id
  end
end
