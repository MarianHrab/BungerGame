class Player < ApplicationRecord
  has_many :votes, dependent: :destroy
  serialize :opened_characteristics, Array, coder: JSON
  serialize :visible_characteristics, Array, coder: JSON
  belongs_to :user
  belongs_to :room
  has_one :characteristic, dependent: :destroy
  attribute :characteristics_visible, :boolean, default: false
  def create_characteristic(attributes = {})
  return if characteristic.present?

  create(
    age: attributes[:age] || rand(18..50),
    height: attributes[:height] || rand(150..200),
    weight: attributes[:weight] || rand(50..100),
    health: attributes[:health] || Characteristic::HEALTH_OPTIONS.sample,
    phobia: attributes[:phobia] || Characteristic::PHOBIA_OPTIONS.sample,
    hobby: attributes[:hobby] || Characteristic::HOBBY_OPTIONS.sample,
    character: attributes[:character] || Characteristic::CHARACTER_OPTIONS.sample,
    luggage: attributes[:luggage] || Characteristic::LUGGAGE_OPTIONS.sample,
    additional_info: attributes[:additional_info] || Faker::Lorem.sentence,
    knowledge: attributes[:knowledge] || Characteristic::KNOWLEDGE_OPTIONS.sample
  )
end
  def get_next_visible_characteristic
    # Отримати всі константи, які починаються зі слова "OPTIONS"
    all_characteristics = Characteristic.constants.select { |c| c.to_s.end_with?('OPTIONS') }.flat_map { |c| Characteristic.const_get(c) }
    # Тут ви можете використовувати all_characteristics як вам потрібно
  end
  
end
