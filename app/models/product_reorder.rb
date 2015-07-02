class ProductReorder < ActiveRecord::Base
  validates :quantity, :estimated_delivery_date, :status,  presence: true

  scope :active, -> { where(status: :active) }

  scope :report_order, -> { order(status: :asc, updated_at: :desc) }
end
