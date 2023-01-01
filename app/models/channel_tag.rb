class ChannelTag < ApplicationRecord
  belongs_to :channel
  attr_accessor :tags  
end
