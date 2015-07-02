class CreateProductReorders < ActiveRecord::Migration
  def change
    create_table :product_reorders do |t|
      t.belongs_to :product, index: true
      t.integer :quantity
      t.date :estimated_delivery_date
      t.date :delivery_date
      t.string :status
      t.timestamps null: false
    end
  end
end
