require 'spec_helper'

RSpec.feature 'Admin Vendor Settings', :js do
  let(:vendor) { create(:active_vendor) }
  let(:blocked_vendor) { create(:blocked_vendor)}
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:user_with_blocked_vendor) { create(:user, vendors: [blocked_vendor]) }

  context 'edit' do
    background do
      login_as(user, scope: :spree_user)
      visit spree.admin_vendor_settings_path
    end

    scenario 'can update current vendor' do
      fill_in 'vendor_name', with: 'Testing edit'
      fill_in 'vendor_about_us', with: 'Testing about us edit'
      fill_in 'vendor_contact_us', with: 'Testing contact us edit'
      expect {
        click_button 'Update'
      }.to change { vendor.reload.slug }.from('active-vendor').to('testing-edit')
      expect(page).to have_text 'Testing edit'
      expect(page).to have_text 'Testing about us edit'
      expect(page).to have_text 'Testing contact us edit'
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

    if Spree.version.to_f >= 3.6
      scenario 'can update an existing vendor image' do
        create(:vendor, name: 'New vendor')
        page.attach_file("vendor_image", Spree::Core::Engine.root + 'spec/fixtures' + 'thinking-cat.jpg')
        click_button 'Update'
        expect(page).to have_css("img[src*='thinking-cat.jpg']")
      end
    end
  end

  context 'no vendor present' do
    before do
      vendor.destroy!
    end

    it 'renders page without errors' do
      visit spree.admin_vendor_settings_path
      expect(page).to have_content Spree::Store.default.name
    end
  end

  context 'blocked vendor present' do
    background do
      login_as(user_with_blocked_vendor, scope: :spree_user)
    end

    it 'renders forbidden page' do
      visit spree.admin_vendor_settings_path
      expect(current_path).to eq spree.forbidden_path
    end
  end
end
