class AddCategoriesToItem < ActiveRecord::Migration[8.0]
  def change
    add_reference :categories, :item
  end
end
