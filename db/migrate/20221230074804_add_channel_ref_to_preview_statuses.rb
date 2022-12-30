class AddChannelRefToPreviewStatuses < ActiveRecord::Migration[7.0]
  def change
    add_index :preview_statuses, :channel_id
  end
end
