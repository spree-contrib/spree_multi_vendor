require 'spec_helper'

RSpec.feature 'Vendors', :js do

  background do
    @vendor = create(:vendor)
    5.times do
      create(:product, vendor: @vendor)
    end
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
    scenario "displays vendor's products" do
      @vendor.products.each do |product|
        expect(page).to have_text product.name
        expect(page).to have_text product.price
      end
    end
  end
end
