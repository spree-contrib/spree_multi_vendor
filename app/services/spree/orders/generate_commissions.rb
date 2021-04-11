module Spree
  module Orders
    class GenerateCommissions
      prepend Spree::ServiceModule::Base

      def call(order:)
        ActiveRecord::Base.transaction do
          run :generate_order_commissions
        end
      end

      private

      def generate_order_commissions(order:)
        return failure(order) unless order.state == 'complete'

        order.vendor_list.each do |vendor|
          amount = if vendor.commission_rate.zero?
                     0.0
                   else
                     order.vendor_pre_tax_item_amount(vendor) * vendor.commission_rate / 100
                   end

          order.commissions.create!(
            amount: amount,
            vendor_id: vendor.id
          )
        end

        success(order: order)
      end
    end
  end
end
