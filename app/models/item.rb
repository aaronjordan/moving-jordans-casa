class Item < ApplicationRecord
  has_rich_text :desc
  has_many :categories
  has_one_attached :cover_image
  has_many_attached :images
end
