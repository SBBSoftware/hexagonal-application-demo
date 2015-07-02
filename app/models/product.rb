class Product < ActiveRecord::Base
  has_many :product_reorders

  # register custom validation
  validate :only_one_active_reorder

  validates :sku, :name, :stock, presence: true

  # validation method to only allow a single reorder to be active
  def only_one_active_reorder
    return unless product_reorders && product_reorders.active.count > 1
    errors.add(:product_reorders, 'Cannot have more than a single active reorder')
  end
end
