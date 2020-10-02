module Spree
  module V2
    module Storefront
      class VendorOrderTotalsSerializer < BaseSerializer
        set_type :vendor_totals

        attributes :name, :subtotal, :ship_total, :total, :display_subtotal,
                   :display_ship_total, :display_total, :promo_total,
                   :display_promo_total, :included_tax_total,
                   :display_included_tax_total, :additional_tax_total,
                   :display_additional_tax_total, :item_count
      end
    end
  end
end
