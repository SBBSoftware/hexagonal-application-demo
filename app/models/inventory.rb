class Inventory < ActiveRecord::Base
  has_many :inventory_reorders

  validates :sku, :name, :stock, presence: true

  # register custom validation
  validate :only_one_active_reorder

  # validation method to only allow a single reorder to be active
  def only_one_active_reorder
    return unless inventory_reorders && inventory_reorders.active.count > 1
    errors.add(:inventory_reorders, 'Cannot have more than a single active reorder')
  end

  # is stock low enough to require a reorder
  def reorder_stock?
    stock < 100 && !current_reorder ? true : false
  end

  # determine which reorder date to use
  def reorder_date
    # todo move out field prioritizationa and selection to module
    return nil unless current_reorder
    current_reorder.delivery_date ? current_reorder.delivery_date : current_reorder.estimated_delivery_date
  end

  # find latest active order
  def current_reorder
    inventory_reorders.active.first
  end

  # create a new reorder if < 100 stock
  def create_reorder
    return nil unless stock < 100
    return nil if current_reorder
    reorder = InventoryReorder.new(status: 'active', quantity: (1000 - stock), estimated_delivery_date: create_default_estimated_date)
    inventory_reorders << reorder
    reorder if save
  end

  # report reorders by active/other status then last updated descending
  def reorder_report
    report = inventory_reorders.report_order
    report.count > 0 ? report : nil
  end

  # logic for a new estimated date is today + 7
  def create_default_estimated_date
    Date.today + 7
  end

end
