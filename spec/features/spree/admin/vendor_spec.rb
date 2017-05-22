require 'spec_helper'

RSpec.feature 'Admin Vendors', :js do
  let!(:admin) { create(:admin_user) }

  background do
    login_as(admin, scope: :spree_user)
    create(:vendor, name: 'My vendor')
    visit spree.admin_vendors_path
  end

  context 'index' do
    scenario 'displays existing vendors' do
      within_row(1) do
        expect(column_text(1)).to eq 'My vendor'
        expect(column_text(2)).to eq 'pending'
      end
    end
  end

  context 'create' do
    scenario 'can create a new vendor' do
      click_link 'New Vendor'
      expect(current_path).to eq spree.new_admin_vendor_path

      fill_in 'vendor_name', with: 'Test'
      select 'Blocked'

      click_button 'Create'

      expect(page).to have_text 'successfully created!'
      expect(current_path).to eq spree.admin_vendors_path
    end

    scenario 'shows validation error with blank name' do
      click_link 'New Vendor'
      expect(current_path).to eq spree.new_admin_vendor_path

      fill_in 'vendor_name', with: ''
      click_button 'Create'

      expect(page).to have_text 'name can\'t be blank'
    end

    scenario 'shows validation error with repeated name' do
      click_link 'New Vendor'
      expect(current_path).to eq spree.new_admin_vendor_path

      fill_in 'vendor_name', with: 'My vendor'
      click_button 'Create'

      expect(page).to have_text 'name has already been taken'
    end
  end

  context 'edit' do
    background do
      within_row(1) { click_icon :edit }
      expect(current_path).to eq spree.edit_admin_vendor_path(1)
    end

    scenario 'can update an existing vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      click_button 'Update'
      expect(page).to have_text 'successfully updated!'
      expect(page).to have_text 'Testing edit'
    end

    scenario 'shows validation error with blank name' do
      fill_in 'vendor_name', with: ''
      click_button 'Update'
      expect(page).to have_text 'name can\'t be blank'
    end

    scenario 'shows validation error with repeated name' do
      create(:vendor, name: 'New vendor')

      fill_in 'vendor_name', with: 'New vendor'
      click_button 'Update'
      expect(page).to have_text 'name has already been taken'
    end
  end
end
