module SpreeMultiVendor
  module Spree
    module Api
      module ApiHelpersDecorator
        def self.prepended(base)
          base::ATTRIBUTES.push(:vendor_attributes)

          base.mattr_reader *base::ATTRIBUTES

          base.user_attributes << :vendor_ids
        end

        @@vendor_attributes = [:id, :name, :slug, :state, :about_us, :contact_us]
      end
    end
  end
end

if SpreeMultiVendor::Engine.api_v1_available?
  ::Spree::Api::ApiHelpers.prepend(SpreeMultiVendor::Spree::Api::ApiHelpersDecorator)
end

