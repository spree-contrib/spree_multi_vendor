Spree::Property.class_eval do
  self.whitelisted_ransackable_associations = %w[vendor]
end
