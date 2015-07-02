FactoryGirl.define do

  factory :product do
    sku '000-0000-00000'
    name 'I have a name'
    blurb 'Something to say'
    stock 2000

    factory :product_with_estimated_delivery_date, class: Product do
      after(:build) do |product|
        product.product_reorders << create(:product_reorder)
      end
    end

    factory :product_with_delivery_date, class: Product do
      after(:build) do |product|
        product.product_reorders << create(:product_reorder_with_delivery_date)
      end
    end

    factory :product_with_multiple_reorders, class: Product do
      after(:build) do |product|
        product.product_reorders << create(:inactive_product_reorder)
        product.product_reorders << create(:product_reorder_with_delivery_date)
        product.product_reorders << create(:inactive_product_reorder)
      end
    end


    factory :product_needing_reorder, class: Product do
      stock 99
    end


  end
end
