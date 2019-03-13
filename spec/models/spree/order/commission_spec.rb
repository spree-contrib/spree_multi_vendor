require 'spec_helper'

describe Spree::Order::Commission do
  describe 'associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:vendor) }
  end
end
