class Player < ApplicationRecord
  serialize :opened_characteristics, Array, coder: JSON
  serialize :visible_characteristics, Array, coder: JSON
  belongs_to :user
  belongs_to :room
  has_one :characteristic, dependent: :destroy
  attribute :characteristics_visible, :boolean, default: false
  def create_initial_characteristic
    return if characteristic.present? # Якщо характеристика вже існує, нічого не робити

    create_characteristic(
      age: rand(18..50),
      height: rand(150..200),
      weight: rand(50..100),
      health: Characteristic::HEALTH_OPTIONS.sample,
      phobia: Characteristic::PHOBIA_OPTIONS.sample,
      hobby: Characteristic::HOBBY_OPTIONS.sample,
      character: Characteristic::CHARACTER_OPTIONS.sample,
      luggage: Characteristic::LUGGAGE_OPTIONS.sample,
      additional_info: Faker::Lorem.sentence,
      knowledge: Characteristic::KNOWLEDGE_OPTIONS.sample
    )
  end
  def get_next_visible_characteristic
    # Отримати всі константи, які починаються зі слова "OPTIONS"
    all_characteristics = Characteristic.constants.select { |c| c.to_s.end_with?('OPTIONS') }.flat_map { |c| Characteristic.const_get(c) }
    # Тут ви можете використовувати all_characteristics як вам потрібно
  end
  
  # def get_next_visible_characteristic
  #   # Припустимо, що у вас є масив доступних характеристик
  #   available_characteristics = Characteristic::ALL_CHARACTERISTICS
  #   # ALL_CHARACTERISTICS може бути масивом у вашій моделі Characteristic,
  #   # який містить всі можливі характеристики

  #   # Перевірте, чи гравець вже має всі доступні характеристики
  #   if visible_characteristics.length >= available_characteristics.length
  #     return nil # Якщо всі характеристики вже видимі, можна повернути nil або вам потрібно визначити іншу логіку
  #   end

  #   # Знайдіть наступну характеристику, яку гравець робить видимою
  #   next_characteristic = (available_characteristics - visible_characteristics).sample

  #   return next_characteristic
  # end
end
