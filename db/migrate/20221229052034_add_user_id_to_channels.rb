class AddUserIdToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :user_id, :integer
    add_index :channels, :user_id
  end
end
