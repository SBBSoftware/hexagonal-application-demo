module Sbb
  module Repository
    class ProductsRepository
      extend SbbHexagonal::RepositoryDAO

      my_dao_is Product

      def self.delete_all_reorders(product)
        product.product_reorders.delete_all
      end

      def self.reorder_stock?(product)
        product.stock < 100 && !current_reorder(product) ? true : false
      end

      # find latest active order
      def self.current_reorder(product)
        product.product_reorders.active.first
      end

      # determine which reorder date to use
      def self.reorder_date(product)
        return nil unless current_reorder(product)
        current_reorder(product).delivery_date ? current_reorder(product).delivery_date : current_reorder(product).estimated_delivery_date
      end

      def self.create_reorder(product)
        return nil unless product.stock < 100
        reorder = ProductReorder.new(status: 'active', quantity: (1000 - product.stock), estimated_delivery_date: create_default_estimated_date)
        product.product_reorders << reorder
        reorder if product.save
      end

      # report reorders by active/other status then last updated descending
      def self.reorder_report(product)
        report = product.product_reorders.report_order
        report.count > 0 ? report : nil
      end

      # logic for a new estimated date is today + 7
      def self.create_default_estimated_date
        Date.today + 7
      end
    end
  end
end
