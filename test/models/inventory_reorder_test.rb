require 'test_helper'
class InventoryReorderTest < ActiveSupport::TestCase

  should validate_presence_of(:quantity)
  should validate_presence_of(:status)
  should validate_presence_of(:estimated_delivery_date)

  # moved to inventory_test.rb
  # should 'default estimated delivery date to today + 7 business days' do
  #   reorder = InventoryReorder.create
  #   assert_equal Date.today + 7, reorder.estimated_delivery_date
  # end

  # this is redundant
  # should 'validate presence of estimated delivery date' do
  #   inv = InventoryReorder.create(quantity: 500)
  #   inv.estimated_delivery_date = nil
  #   refute inv.save
  #   assert inv.errors.messages[:estimated_delivery_date].include?("can't be blank")
  # end

end
