require 'spec_helper'

describe Spree::Vendor do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'initial state' do
    it 'initial state should be pending' do
      should be_pending
    end
  end
end
