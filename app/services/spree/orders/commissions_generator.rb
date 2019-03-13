module Spree
  module Orders
    class CommissionsGenerator
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def call
        order.line_items.includes(product: :vendor).group_by{ |li| li.product.vendor }.each do |vendor, vendor_line_items|
          order.commissions.create(
              amount: vendor_line_items.pluck(:pre_tax_amount).sum * vendor.commission_rate / 100,
              vendor_id: vendor.id
          )
        end
      end
    end
  end
end
