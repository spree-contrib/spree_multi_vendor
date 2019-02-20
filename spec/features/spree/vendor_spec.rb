require 'spec_helper'

RSpec.feature 'Vendors', :js do

  background do
    @vendor = create(:vendor)
  end

  context 'show' do
    background do
      visit spree.vendor_path(@vendor)
      expect(current_path).to eq spree.vendor_path(@vendor)
    end
    scenario 'displays vendor information' do
      expect(page).to have_text @vendor.name
      expect(page).to have_text @vendor.about_us
      expect(page).to have_text @vendor.contact_us
    end
  end
end
