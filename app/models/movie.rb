class Movie < ApplicationRecord
  has_one_attached :image
  has_and_belongs_to_many :characters, dependent: :destroy
  has_and_belongs_to_many :genres, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :release_date, presence: true
  validates :rating, presence: true, numericality: { greater_than: 0, less_than: 6 }
  validates :image, presence: true
end
