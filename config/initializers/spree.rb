require 'spree_multi_vendor/search'

Spree.config do |config|
  config.searcher_class = SpreeMultiVendor::Search
end
