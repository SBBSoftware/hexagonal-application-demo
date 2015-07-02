# need to add a stock column to product
class AddStockToProducts < ActiveRecord::Migration
  def change
    add_column :products, :stock, :integer
  end
end
