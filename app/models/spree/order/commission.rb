class Spree::Order::Commission < ApplicationRecord
  belongs_to :order
  belongs_to :vendor
end
