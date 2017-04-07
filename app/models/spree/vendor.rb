module Spree
  class Vendor < Spree::Base
    validates :name, presence: true, uniqueness: true
  end
end
