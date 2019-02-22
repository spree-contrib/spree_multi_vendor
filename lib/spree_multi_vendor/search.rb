module SpreeMultiVendor
  class Search < Spree::Core::Search::Base

    protected

    def get_base_scope
      base_scope = super
      base_scope = base_scope.for_vendor(vendor) unless vendor.blank?
      base_scope
    end

    def prepare(params)
      super
      @properties[:vendor] = params[:vendor].blank? ? nil : Spree::Vendor.find(params[:vendor])
    end
  end
end
