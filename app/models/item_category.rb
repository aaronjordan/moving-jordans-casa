class ItemCategory < ApplicationRecord
  belongs_to :item, dependent: :destroy
  belongs_to :category, dependent: :destroy
end
