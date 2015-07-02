require 'test_helper'
class InventoryTest < ActiveSupport::TestCase

  should validate_presence_of(:sku)
  should validate_presence_of(:name)
  should validate_presence_of(:stock)

  should 'reorder stock when stock < 100 and no active reorder' do
    sample = create(:inventory)
    sample.stock = 1000
    refute sample.reorder_stock?
    sample.stock = 50
    assert sample.reorder_stock?
    sample_with_reorder = create(:inventory_with_delivery_date)
    sample_with_reorder.stock = 50
    refute sample_with_reorder.reorder_stock?
    sample_with_reorder.inventory_reorders.delete_all
    assert sample_with_reorder.reorder_stock?
  end

  context 'reorder delivery date' do
    should 'use estimated when delivery date is nil' do
      inventory = create(:inventory_with_estimated_delivery_date)
      assert_nil inventory.inventory_reorders.first.delivery_date
      assert_equal inventory.inventory_reorders.first.estimated_delivery_date, inventory.reorder_date
    end

    should 'use delivery date when it is not nil' do
      inventory = create(:inventory_with_delivery_date)
      refute_nil inventory.inventory_reorders.first.delivery_date
      assert_equal inventory.inventory_reorders.first.delivery_date, inventory.reorder_date
    end
  end

  should 'only allow 1 active reorder' do
    inventory = create(:inventory_with_multiple_reorders)
    assert inventory.valid?
    inventory.inventory_reorders << InventoryReorder.new(status: :active, quantity: 50, estimated_delivery_date: Date.today + 30)
    refute inventory.valid?
    assert_equal 'Cannot have more than a single active reorder', inventory.errors.messages[:inventory_reorders].first
  end

  should 'allow many inactive reorders' do
    inventory = create(:inventory_with_multiple_reorders)
    assert inventory.valid?
  end

  should 'find active reorder' do
    inventory = create(:inventory_with_multiple_reorders)
    assert inventory.inventory_reorders.count > 1
    reorder = inventory.current_reorder
    refute_nil reorder
    assert_equal 'active', reorder.status
  end

  should 'return nil if no active reorder' do
    inventory = create(:inventory)
    assert_empty inventory.inventory_reorders
    assert_nil inventory.current_reorder
  end

  should 'not create reorder unless current stock < 100' do
    inventory = create(:inventory)
    assert_empty inventory.inventory_reorders
    reorder = inventory.create_reorder
    refute reorder
    assert_empty inventory.inventory_reorders
  end

  should 'not create reorder if one exists and is active' do
    inventory = create(:inventory_with_multiple_reorders)
    refute_nil inventory.current_reorder
    reorder = inventory.create_reorder
    assert_nil reorder
  end

  context 'creating reorders' do
    should 'calculate reorder quantity to be 1000 - current stock quantity' do
      inventory = create(:inventory_needing_reorder)
      assert_empty inventory.inventory_reorders
      assert_nil inventory.current_reorder
      inventory.create_reorder
      reorder = inventory.current_reorder
      refute_nil reorder
      assert_equal 'active', reorder.status
      assert_equal 1000, inventory.stock + reorder.quantity
    end

    should 'set estimated delivery date as today + 7 days' do
      inventory = create(:inventory_needing_reorder)
      inventory.create_reorder
      reorder = inventory.current_reorder
      refute_nil reorder
      assert_equal 'active', reorder.status
      assert_equal Date.today + 7, reorder.estimated_delivery_date
    end
  end

  context 'listing reorders' do
    should 'order by status then updated date descending' do
      inventory = create(:inventory_with_multiple_reorders)
      base_reorder = attributes_for(:inactive_inventory_reorder)
      custom_quantity = 99
      inventory.inventory_reorders[2].quantity = custom_quantity
      inventory.inventory_reorders[2].save!
      reorders = inventory.reorder_report
      assert_equal 'active', reorders.first.status
      assert_equal base_reorder[:quantity], reorders.last.quantity
      assert_equal custom_quantity, reorders[1].quantity
    end

    should 'return nil when no reorders exist' do
      inv = create(:inventory)
      assert_equal 0, inv.inventory_reorders.count
      report = inv.reorder_report
      refute report
    end
  end

end
