module SpreeMultiVendor
  module ProductsFinderDecorator
    def initialize(scope:, params:, current_currency:)
      super

      @vendors = params.dig(:filter, :vendor_ids)&.split(',')
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

    def by_vendors(products)
      return products unless vendors?

      products.where(vendor_id: vendors)
    end
  end
end

::Spree::Products::Find.prepend(SpreeMultiVendor::ProductsFinderDecorator)
