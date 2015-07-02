FactoryGirl.define do
  factory :inventory_reorder do
    quantity 1000
    estimated_delivery_date (Date.today + 7)
    status :active

    factory :inventory_reorder_with_delivery_date, class: InventoryReorder do
      delivery_date (Date.today + 8)
    end

    factory :inactive_inventory_reorder, class: InventoryReorder do
      delivery_date (Date.today - 800)
      status :inactive
    end
  end
end
