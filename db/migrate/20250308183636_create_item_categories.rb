class CreateItemCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :item_categories do |t|
      t.references :item, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
