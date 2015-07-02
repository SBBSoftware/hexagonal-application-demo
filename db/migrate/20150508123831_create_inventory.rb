class CreateInventory < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.string :sku
      t.string :name
      t.string :blurb
      t.integer :stock
      t.timestamps null: false
    end

    create_table :inventory_reorders do |t|
      t.belongs_to :inventory, index: true
      t.integer :quantity
      t.date :estimated_delivery_date
      t.date :delivery_date
      t.string :status
      t.timestamps null: false
    end

  end
end
