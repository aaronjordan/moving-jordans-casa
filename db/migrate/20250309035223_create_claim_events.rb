class CreateClaimEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :claim_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.boolean :released

      t.timestamps
    end
  end
end
