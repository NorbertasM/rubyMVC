class Channel < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :channel_game
  has_one :preview_statuses
  has_many :channel_tags
  has_many :channel_status
  attr_accessor :games
  attr_accessor :language
  attr_accessor :status
end
