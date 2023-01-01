class CreateChannelGames < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_games do |t|
      t.integer :game_id
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
