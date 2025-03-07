class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :tag
      t.string :title
      t.string :color

      t.timestamps
    end
  end
end
