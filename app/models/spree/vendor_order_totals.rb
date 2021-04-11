module Spree
  class VendorOrderTotals
    include ActiveModel::Model

    METHOD_NAMES = %w[
      total ship_total subtotal included_tax_total additional_tax_total promo_total
      pre_tax_item_amount pre_tax_ship_amount pre_tax_total
    ].freeze

    attr_accessor :vendor, :order

    delegate :id, :name, to: :vendor

    METHOD_NAMES.each do |method_name|
      define_method(method_name) do
        order.send("vendor_#{method_name}", vendor)
      end

      define_method("display_#{method_name}") do
        order.send("display_vendor_#{method_name}", vendor)
      end
    end

    def item_count
      order.vendor_item_count(vendor)
    end
  end
end
