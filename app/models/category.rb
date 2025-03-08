class Category < ApplicationRecord
  has_rich_text :desc
  has_many :item_categories
  has_many :items, through: :item_categories
end
