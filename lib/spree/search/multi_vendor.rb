module Spree::Search
  class MultiVendor < Spree::Core::Search::Base
    def extended_base_scope
      base_scope = Spree::Product.spree_base_scopes.active
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = Spree::Dependencies.products_finder.constantize.new(
        scope: base_scope,
        params: {
          filter: {
            option_value_ids: option_value_ids,
            price: price,
            vendors: vendors,
            taxons: taxon&.id
          },
          sort_by: sort_by
        },
        current_currency: current_currency
      ).execute
      base_scope = add_search_scopes(base_scope)
      base_scope = add_eagerload_scopes(base_scope)
      base_scope
    end

    def prepare(params)
      super
      @properties[:vendors] = params[:vendors].blank? ? nil : params[:vendors]
    end
  end
end