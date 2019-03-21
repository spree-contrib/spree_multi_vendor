require 'spec_helper'

describe Spree::OptionType do
  describe 'associations' do
    it { is_expected.to belong_to(:vendor).optional }
  end
end
