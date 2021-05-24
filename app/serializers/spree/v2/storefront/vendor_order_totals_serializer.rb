module Spree
  module V2
    module Storefront
      class VendorOrderTotalsSerializer < BaseSerializer
        set_type :vendor_totals

        cache_options store: nil

        attributes :name, :subtotal, :ship_total, :total, :display_subtotal,
                   :display_ship_total, :display_total, :promo_total,
                   :display_promo_total, :included_tax_total,
                   :display_included_tax_total, :additional_tax_total,
                   :display_additional_tax_total, :item_count,
                   :pre_tax_item_amount, :display_pre_tax_item_amount,
                   :pre_tax_ship_amount, :display_pre_tax_ship_amount,
                   :pre_tax_total, :display_pre_tax_total
      end
    end
  end
end
