class Recipe < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
