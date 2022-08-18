class Character < ApplicationRecord
  has_one_attached :image
  has_and_belongs_to_many :movies, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 150 }
  validates :weight, presence: true, numericality: { greater_than: 0, less_than: 150 }
  validates :history, presence: true, length: { maximum: 2000 }
  validates :image, presence: true
end
