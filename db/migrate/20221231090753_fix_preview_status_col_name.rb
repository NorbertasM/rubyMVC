class FixPreviewStatusColName < ActiveRecord::Migration[7.0]
  def change
    rename_column :preview_statuses, :preview_id, :status_id
  end
end
