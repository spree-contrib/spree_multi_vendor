module Spree::PropertyDecorator
  Spree::Property.whitelisted_ransackable_associations = %w[vendor]
end

Spree::Property.prepend Spree::PropertyDecorator
