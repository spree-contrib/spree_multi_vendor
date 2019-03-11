require 'spec_helper'

RSpec.feature 'Admin Vendors', :js do
  let!(:admin) { create(:admin_user) }

  background do
    login_as(admin, scope: :spree_user)
    create(:active_vendor) if Spree::Vendor.find_by(name: 'Active vendor').nil?
    visit spree.admin_vendors_path
  end

  context 'index' do
    scenario 'displays existing vendors' do
      within_row(1) do
        expect(column_text(1)).to eq ''
        expect(column_text(2)).to eq 'Active vendor'
        expect(column_text(3)).to eq 'active'
        expect(column_text(4)).to eq 'About us...'
        expect(column_text(5)).to eq 'Contact us...'
        if Spree.version.to_f >= 3.6
          expect(column_text(6)).to eq ''
        end
      end
    end
  end

  context 'create' do
    scenario 'can create a new vendor' do
      click_link 'New Vendor'
      expect(current_path).to eq spree.new_admin_vendor_path

      fill_in 'vendor_name', with: 'Test'
      fill_in 'vendor_about_us', with: 'About...'
      fill_in 'vendor_contact_us', with: 'Contact...'
      expect(find_field('vendor_commission_rate').value).to eq '5.0'
      if Spree.version.to_f >= 3.6
        page.attach_file("vendor_image", Spree::Core::Engine.root + 'spec/fixtures' + 'thinking-cat.jpg')
      end
      select 'Blocked'

      click_button 'Create'

      expect(page).to have_text 'successfully created!'
      expect(current_path).to eq spree.admin_vendors_path
      if Spree.version.to_f >= 3.6
        expect(page).to have_css("img[src*='thinking-cat.jpg']")
      end
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

      fill_in 'vendor_name', with: 'Active vendor'
      click_button 'Create'

      expect(page).to have_text 'name has already been taken'
    end
  end

  context 'edit' do
    background do
      within_row(1) { click_icon :edit }
      expect(current_path).to eq spree.edit_admin_vendor_path('active-vendor')
    end

    scenario 'can update an existing vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      fill_in 'vendor_about_us', with: 'Testing about us'
      fill_in 'vendor_contact_us', with: 'Testing contact us'
      fill_in 'vendor_commission_rate', with: '5.5'
      click_button 'Update'
      expect(page).to have_text 'successfully updated!'
      expect(page).to have_text 'Testing edit'
      expect(page).to have_text 'Testing about us'
      expect(page).to have_text 'Testing contact us'
    end

    if Spree.version.to_f >= 3.6
      scenario 'can update an existing vendor image' do
        page.attach_file("vendor_image", Spree::Core::Engine.root + 'spec/fixtures' + 'thinking-cat.jpg')
        expect { click_button 'Update' }.to change(Spree::VendorImage, :count).by(1)
        expect(page).to have_css("img[src*='thinking-cat.jpg']")
        expect(page).to have_text 'successfully updated!'
      end
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

    scenario 'does not show validation error with blank contact_us' do
      fill_in 'vendor_contact_us', with: ''
      click_button 'Update'
      expect(page).not_to have_text 'contact_us can\'t be blank'
    end

    scenario 'shows validation error with repeated name' do
      create(:vendor, name: 'New vendor')

      fill_in 'vendor_name', with: 'New vendor'
      click_button 'Update'
      expect(page).to have_text 'name has already been taken'
    end
  end
end
