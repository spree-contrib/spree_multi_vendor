module Spree
  module Orders
    class GenerateCommissions
      prepend Spree::ServiceModule::Base

      def call(order)
        ActiveRecord::Base.transaction do
          run :generate_order_commissions
        end
      end

      private

      def generate_order_commissions(order)
        return failure(order) unless order.state == 'complete'

        order.line_items.includes(product: :vendor).group_by{ |li| li.product.vendor }.each do |vendor, vendor_line_items|
          next unless vendor
          order.commissions.create(
              amount: vendor_line_items.pluck(:pre_tax_amount).sum * vendor.commission_rate / 100,
              vendor_id: vendor.id
          )
        end

        success(order: order)
      end
    end
  end
end
