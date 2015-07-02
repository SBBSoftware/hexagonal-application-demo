FactoryGirl.define do

  factory :inventory do
    sku '000-0000-00000'
    name 'I have a name'
    blurb 'Something to say'
    stock 2000

    factory :inventory_with_estimated_delivery_date, class: Inventory do
      after(:build) do |product|
        product.inventory_reorders << create(:inventory_reorder)
      end
    end

    factory :inventory_with_delivery_date, class: Inventory do
      after(:build) do |product|
        product.inventory_reorders << create(:inventory_reorder_with_delivery_date)
      end
    end

    factory :inventory_with_multiple_reorders, class: Inventory do
      after(:build) do |product|
        product.inventory_reorders << create(:inactive_inventory_reorder)
        product.inventory_reorders << create(:inventory_reorder_with_delivery_date)
        product.inventory_reorders << create(:inactive_inventory_reorder)
      end
    end

    factory :inventory_needing_reorder, class: Inventory do
      stock 99
    end

  end
end
