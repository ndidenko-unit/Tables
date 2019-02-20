class Restaurant < ApplicationRecord
  has_many :tables

  validates :open_time, presence: true
  validates :close_time, presence: true
end
