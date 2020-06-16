module Spree
  module Products
    class FindMultiVendor < Spree::Products::Find
      def initialize(scope:, params:, current_currency:)
        super 
        @vendors = String(params.dig(:filter, :vendors)).split(',')
      end

      def execute
        products = by_ids(scope)
        products = by_skus(products)
        products = by_price(products)
        products = by_vendors(products)
        products = by_taxons(products)
        products = by_name(products)
        products = by_options(products)
        products = by_option_value_ids(products)
        products = include_deleted(products)
        products = include_discontinued(products)
        products = ordered(products)

        products
      end

      private

      attr_reader :vendors

      def by_vendors(products)
        return products unless vendors?

        # not necessary it will be id - use friendly
        # Spree::Product.merge(Spree::Vendor.first.products).count ?
        products.joins(:vendor).distinct.where(spree_vendors: { id: vendors })
      end

      def vendors?
        vendors&.any?
      end
    end
  end
end
