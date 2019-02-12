module SpreeMultiVendor
  module AbilityActivator
    private
    def abilities_to_register
      super << Spree::VendorAbility
    end
  end
end

Spree::Ability.prepend SpreeMultiVendor::AbilityActivator
