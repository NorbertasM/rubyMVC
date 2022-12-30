class AddLanguageIdToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :language_id, :integer
  end
end
