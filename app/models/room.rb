class Room < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :players, dependent: :destroy
  has_many :users, through: :players

  validates :name, presence: true
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }

  enum turn_status: { waiting_for_characteristic: 0, voting: 1 }

  serialize :current_turn_data, Hash, coder: JSON
  validates :turn_status, inclusion: { in: %w(waiting_for_characteristic voting result_announced game_over),
    message: "%{value} is not a valid turn_status" }

end