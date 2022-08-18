class Genre < ApplicationRecord
  has_one_attached :image
  has_and_belongs_to_many :movies, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :image, presence: true
end
