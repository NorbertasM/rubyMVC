class Channel < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id
  has_many :channel_game
  has_many :preview_statuses
  has_many :channel_tags
  has_many :channel_status
  attr_accessor :games
  attr_accessor :language
  attr_accessor :status
  attr_accessor :p_status
  attr_accessor :tags

  validates_presence_of :about
  validates_presence_of :description
  validates_presence_of :language_id

  validates :title, presence: true, length: { maximum: 35 }

  validates :preview_url, presence: true, format: { with: /^(ftp|http|https):\/\/[^ "]+$/, multiline: true, message: "Invalid URL format" }
  validates :stream_link, presence: true, format: { with: /^(ftp|http|https):\/\/[^ "]+$/, multiline: true, message: "Invalid URL format" }
end
