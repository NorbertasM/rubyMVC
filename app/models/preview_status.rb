class PreviewStatus < ApplicationRecord
  belongs_to :channel
  attr_accessor :duration
end
