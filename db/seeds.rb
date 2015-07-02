def load_products
  # products for the repo demo
  Product.create_with(name: 'The Living Planet', blurb: 'Attenborough at his finest', stock: 200).find_or_create_by(sku: '12345-01')
  Product.create_with(name: 'The First Eden', blurb: 'Attenborough at his finest', stock: 2000).find_or_create_by(sku: '12345-02')
  Product.create_with(name: 'Lost Worlds, Vanished Lives', blurb: 'Attenborough at his finest', stock: 1000).find_or_create_by(sku: '12345-03')
  Product.create_with(name: 'The Discoverers', blurb: 'Attenborough at his finest', stock: 300).find_or_create_by(sku: '12345-08')

  Product.create_with(name: 'The Trials of Life', blurb: 'Attenborough at his finest', stock: 0).find_or_create_by(sku: '12345-04') do |product|
    product.product_reorders.new(status: 'active', quantity: 1000, estimated_delivery_date: Date.today + 7)
  end
  Product.create_with(name: 'Life in the Freezer', blurb: 'Attenborough at his finest', stock: 50).find_or_create_by(sku: '12345-05')  do |product|
    product.product_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 40, estimated_delivery_date: Date.today - 40)
    product.product_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 30, estimated_delivery_date: Date.today - 30)
    product.product_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 20, estimated_delivery_date: Date.today - 20)
    product.product_reorders.new(status: 'active', quantity: 1000, delivery_date: Date.today + 1, estimated_delivery_date: Date.today + 7)
  end
  Product.create_with(name: 'The Private Life of Plants', blurb: 'Attenborough at his finest', stock: 65).find_or_create_by(sku: '12345-06') do |product|
    product.product_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 40, estimated_delivery_date: (Date.today - 40))
    product.product_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 30, estimated_delivery_date: Date.today - 30)
    product.product_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 150, estimated_delivery_date: Date.today - 20)
  end
  Product.create_with(name: 'Wildlife on One', blurb: 'Attenborough at his finest', stock: 90).find_or_create_by(sku: '12345-07')


  # inventory for the fat model demo
  Inventory.create_with(name: 'The Living Planet', blurb: 'Attenborough at his finest', stock: 200).find_or_create_by(sku: '12345-01')
  Inventory.create_with(name: 'The First Eden', blurb: 'Attenborough at his finest', stock: 2000).find_or_create_by(sku: '12345-02')
  Inventory.create_with(name: 'Lost Worlds, Vanished Lives', blurb: 'Attenborough at his finest', stock: 1000).find_or_create_by(sku: '12345-03')
  Inventory.create_with(name: 'The Discoverers', blurb: 'Attenborough at his finest', stock: 300).find_or_create_by(sku: '12345-08')

  Inventory.create_with(name: 'The Trials of Life', blurb: 'Attenborough at his finest', stock: 0).find_or_create_by(sku: '12345-04') do |inventory|
    inventory.inventory_reorders.new(status: 'active', quantity: 1000, estimated_delivery_date: Date.today + 7)
  end
  Inventory.create_with(name: 'Life in the Freezer', blurb: 'Attenborough at his finest', stock: 50).find_or_create_by(sku: '12345-05') do |inventory|
    inventory.inventory_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 40, estimated_delivery_date: Date.today - 40)
    inventory.inventory_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 30, estimated_delivery_date: Date.today - 30)
    inventory.inventory_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 20, estimated_delivery_date: Date.today - 20)
    inventory.inventory_reorders.new(status: 'active', quantity: 1000, delivery_date: Date.today + 1, estimated_delivery_date: Date.today + 7)
  end
  Inventory.create_with(name: 'The Private Life of Plants', blurb: 'Attenborough at his finest', stock: 65).find_or_create_by(sku: '12345-06') do |inventory|
    inventory.inventory_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 40, estimated_delivery_date: (Date.today - 40))
    inventory.inventory_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 30, estimated_delivery_date: Date.today - 30)
    inventory.inventory_reorders.new(status: 'delivered', quantity: 1000, delivery_date: Date.today - 150, estimated_delivery_date: Date.today - 20)
  end
  Inventory.create_with(name: 'Wildlife on One', blurb: 'Attenborough at his finest', stock: 90).find_or_create_by(sku: '12345-07')
end


seed_products = true
load_products if seed_products
