class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :title
      t.boolean :draft
      t.decimal :suggested_price
      t.decimal :reserve_price

      t.timestamps
    end
  end
end
