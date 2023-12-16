class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :owned_rooms, class_name: 'Room', foreign_key: 'owner_id'
  has_many :players, dependent: :destroy
  has_many :rooms, through: :players

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         
  has_one :profile
  after_create :create_default_profile

  def create_default_profile
    Profile.create(user: self, name: email) unless profile
  end

end
