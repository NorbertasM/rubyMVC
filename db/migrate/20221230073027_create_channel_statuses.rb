class CreateChannelStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_statuses do |t|
      t.integer :channel_id
      t.integer :status_id

      t.timestamps
    end
  end
end
