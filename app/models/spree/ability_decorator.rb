module Spree::AbilityDecorator
  private

  def abilities_to_register
    super << Spree::VendorAbility
  end
end

Spree::Ability.prepend Spree::AbilityDecorator
