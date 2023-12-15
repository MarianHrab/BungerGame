class Room < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :players, dependent: :destroy
  has_many :users, through: :players

  validates :name, presence: true
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }

  enum status: { waiting_for_characteristic: 0, voting: 1, result_announced: 2 }

  serialize :current_turn_data, Hash, coder: JSON

  # Add this line to define the voted_out_player_id attribute
  attribute :voted_out_player_id, :integer
end