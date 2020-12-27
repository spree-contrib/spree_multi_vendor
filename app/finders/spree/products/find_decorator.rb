module Spree
  module Products
    module FindDecorator
      def initialize(scope:, params:, current_currency:)
        super

        @vendors = vendors_by_slugs(params.dig(:filter, :vendor_slugs))
      end

      def execute
        products = by_vendors(super)

        products.distinct
      end

      private

      attr_reader :vendors

      def vendors?
        vendors.present?
      end

      def vendors_by_slugs(vendor_slugs)
        return if vendor_slugs.nil? || vendor_slugs.to_s.blank?

        Spree::Vendor.where(slug: vendor_slugs.to_s.split(','))
      end

      def by_vendors(products)
        return products unless vendors?

        products.where(vendor_id: vendors)
      end

      Spree::Products::Find.prepend self
    end
  end
end
