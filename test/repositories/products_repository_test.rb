require 'test_helper'
# test class for app/models/ProductsRepository
class ProductsRepositoryTest < ActiveSupport::TestCase

  setup do
    @repo = Sbb::Repository::ProductsRepository
  end

  context 'crud operations' do
    should 'create product' do
      assert_difference('Product.count') do
        product = @repo.create(attributes_for(:product))
        assert_not_nil product
      end
    end

    should 'read product' do
      product = create(:product)
      found_product = @repo.find(product.id)
      assert_not_nil found_product
      assert_equal product.sku, found_product.sku
    end

    should 'get all products' do
      create(:product)
      create(:product_needing_reorder)
      products = @repo.all
      assert_equal 2, products.count
    end

    should 'update product' do
      product = create(:product)
      changed_name = 'I am now changed'
      product.name = changed_name
      result = product.save
      assert result
      assert changed_name, @repo.all.first.name
    end

    should 'delete product' do
      assert_no_difference('Product.count') do
        product = create(:product)
        product.delete
      end
    end
  end

  should 'reorder stock when stock < 100 and no active reorder' do
    sample = create(:product)
    sample.stock = 1000
    refute @repo.reorder_stock?(sample)
    sample.stock = 50
    assert @repo.reorder_stock?(sample)
    sample_with_reorder = create(:product_with_delivery_date)
    sample_with_reorder.stock = 50
    refute @repo.reorder_stock?(sample_with_reorder)
    @repo.delete_all_reorders(sample_with_reorder)
    assert @repo.reorder_stock?(sample_with_reorder)
  end

  context 'reorder delivery date' do
    should 'use estimated when delivery date is nil' do
      product = create(:product_with_estimated_delivery_date)
      assert_nil product.product_reorders.first.delivery_date
      assert_equal product.product_reorders.first.estimated_delivery_date, @repo.reorder_date(product)
    end

    should 'use delivery date when it is not nil' do
      product = create(:product_with_delivery_date)
      refute_nil product.product_reorders.first.delivery_date
      assert_equal product.product_reorders.first.delivery_date, @repo.reorder_date(product)
    end
  end

  should 'only allow 1 active reorder' do
    product = create(:product_with_multiple_reorders)
    assert product.valid?
    product.product_reorders << ProductReorder.new(status: :active, quantity: 50, estimated_delivery_date: Date.today + 30)
    refute product.valid?
    assert_equal 'Cannot have more than a single active reorder', product.errors.messages[:product_reorders].first
  end

  should 'allow many inactive reorders' do
    product = create(:product_with_multiple_reorders)
    assert product.valid?
  end

  should 'find active reorder' do
    product = create(:product_with_multiple_reorders)
    assert product.product_reorders.count > 1
    reorder = @repo.current_reorder(product)
    refute_nil reorder
    assert_equal 'active', reorder.status
  end

  should 'return nil if no active reorder' do
    product = create(:product)
    assert_empty product.product_reorders
    assert_nil @repo.current_reorder(product)
  end

  should 'not create reorder unless current stock < 100' do
    product = create(:product)
    assert_empty product.product_reorders
    reorder = @repo.create_reorder(product)
    refute reorder
    assert_empty product.product_reorders
  end

  should 'not create reorder if one exists and is active' do
    product = create(:product_with_multiple_reorders)
    refute_nil @repo.current_reorder(product)
    reorder = @repo.create_reorder(product)
    assert_nil reorder
  end

  context 'creating reorders' do
    should 'calculate reorder quantity to be 1000 - current stock quantity' do
      product = create(:product_needing_reorder)
      assert_empty product.product_reorders
      assert_nil @repo.current_reorder(product)
      @repo.create_reorder(product)
      reorder = @repo.current_reorder(product)
      refute_nil reorder
      assert_equal 'active', reorder.status
      assert_equal 1000, product.stock + reorder.quantity
    end

    should 'set estimated delivery date as today + 7 days' do
      product = create(:product_needing_reorder)
      @repo.create_reorder(product)
      reorder = @repo.current_reorder(product)
      refute_nil reorder
      assert_equal 'active', reorder.status
      assert_equal Date.today + 7, reorder.estimated_delivery_date
    end
  end

  context 'listing reorders' do

    should 'order by status then updated date descending' do
      product = create(:product_with_multiple_reorders)
      base_reorder = attributes_for(:inactive_product_reorder)
      custom_quantity = 99
      product.product_reorders[2].quantity = custom_quantity
      product.product_reorders[2].save!
      reorders = @repo.reorder_report(product)
      assert_equal 'active', reorders.first.status
      assert_equal base_reorder[:quantity], reorders.last.quantity
      assert_equal custom_quantity, reorders[1].quantity
    end

    should 'return nil when no reorders exist' do
      product = create(:product)
      assert_equal 0, product.product_reorders.count
      report = @repo.reorder_report(product)
      refute report
    end
  end
end
