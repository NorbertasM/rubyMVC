class AddAboutToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :about, :text
  end
end
