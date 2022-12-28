class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels do |t|
      t.string :title
      t.text :description
      t.text :stream_link
      t.text :preview_url

      t.timestamps
    end
  end
end
