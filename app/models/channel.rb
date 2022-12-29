class Channel < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :channel_game
end
