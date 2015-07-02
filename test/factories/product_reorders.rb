FactoryGirl.define do
  factory :product_reorder do
    quantity 1000
    estimated_delivery_date (Date.today + 7)
    status :active

    factory :product_reorder_with_delivery_date, class: ProductReorder do
      delivery_date (Date.today + 8)
    end

    factory :inactive_product_reorder, class: ProductReorder do
      delivery_date (Date.today - 800)
      status :inactive
    end
  end
end
