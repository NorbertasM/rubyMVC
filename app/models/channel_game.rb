class ChannelGame < ApplicationRecord
  belongs_to :channel
  attr_accessor :games
end
