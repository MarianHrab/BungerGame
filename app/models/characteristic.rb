class Characteristic < ApplicationRecord
  belongs_to :player, dependent: :destroy
  HEALTH_OPTIONS = ['Full healthy', 'Good', 'Average', 'Poor'].freeze
  PHOBIA_OPTIONS = ['Heights', 'Spiders', 'Public speaking', 'Clowns'].freeze
  HOBBY_OPTIONS = ['Reading', 'Painting', 'Gardening', 'Cooking'].freeze
  CHARACTER_OPTIONS = ['Adventurous', 'Cautious', 'Optimistic', 'Pessimistic'].freeze
  LUGGAGE_OPTIONS = ['Backpack', 'Suitcase', 'Duffle bag', 'No baggage'].freeze
  KNOWLEDGE_OPTIONS = ['Science', 'History', 'Technology', 'Art'].freeze
  def visible_characteristics
    # Додайте логіку для визначення видимих характеристик
    # Наприклад, якщо ви хочете бачити тільки характеристики з певного списку, скористайтеся фільтрацією.
    available_characteristics = ['age', 'height', 'weight', 'health', 'phobia', 'hobby', 'character', 'luggage', 'knowledge']

    # Повернути тільки ті характеристики, які є в списку доступних
    available_characteristics & self.attributes.keys
  end
end
