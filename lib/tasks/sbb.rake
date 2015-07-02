namespace :sbb do
  desc 'delete all products'
  task delete_products: :environment do
    ProductReorder.delete_all
    Product.delete_all
    InventoryReorder.delete_all
    Inventory.delete_all
  end

end
