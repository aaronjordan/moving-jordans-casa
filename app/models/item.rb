class Item < ApplicationRecord
  has_rich_text :desc
  has_many :item_categories
  has_many :categories, through: :item_categories
  has_one_attached :cover_image
  has_many_attached :images

  def is_available?
    claims = ClaimEvent.where(item_id: id)
    claims.empty? || claims.all? { |c| c.released }
  end
end
