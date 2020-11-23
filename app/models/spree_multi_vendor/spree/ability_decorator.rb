module SpreeMultiVendor::Spree::AbilityDecorator
  private

  def abilities_to_register
    super << Spree::VendorAbility
  end
end

Spree::Ability.prepend SpreeMultiVendor::Spree::AbilityDecorator
