require 'spec_helper'

describe Spree::VendorUser do
  describe 'associations' do
    it { is_expected.to belong_to(:vendor) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:vendor_id).scoped_to(:user_id) }
  end
end
