class CreatePreviewStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :preview_statuses do |t|
      t.integer :channel_id
      t.integer :preview_id
      t.datetime :valid_until

      t.timestamps
    end
  end
end
