module Spree
  Ability.class_eval do
    private

    def abilities_to_register
      [Spree::VendorAbility]
    end
  end
end
