require 'spec_helper'

RSpec.feature 'Admin Vendor Settings', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }

  context 'edit' do
    background do
      login_as(user, scope: :spree_user)
      visit spree.admin_vendor_settings_path
    end

    scenario 'can update current vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      fill_in 'vendor_about_us', with: 'Testing about us edit'
      click_button 'Update'
      expect(page).to have_text 'Testing edit'
      expect(page).to have_text 'Testing about us edit'
    end

    scenario 'shows validation error with blank name' do
      fill_in 'vendor_name', with: ''
      click_button 'Update'
      expect(page).to have_text 'name can\'t be blank'
    end

    scenario 'does not show validation error with blank about_us' do
      fill_in 'vendor_about_us', with: ''
      click_button 'Update'
      expect(page).not_to have_text 'about_us can\'t be blank'
    end
  end
end
