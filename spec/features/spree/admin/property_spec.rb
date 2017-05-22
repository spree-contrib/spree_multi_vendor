require 'spec_helper'

RSpec.feature 'Admin Property', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:property) { create(:property, name: 'Test1') }
  let!(:vendor_property) { create(:property, vendor_id: vendor.id, name: 'Test2') }

  context 'for user with admin role' do
    context 'index' do
      scenario 'displays all properties' do
        login_as(admin, scope: :spree_user)
        visit spree.admin_properties_path
        expect(page).to have_selector('tr', count: 3)
      end
    end
  end

  context 'for user with vendor' do
    before(:each) do
      login_as(user, scope: :spree_user)
      visit spree.admin_properties_path
    end

    context 'index' do
      scenario 'displays only vendor properties' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    context 'create' do
      scenario 'can create a new property' do
        click_link 'New Property'
        expect(current_path).to eq spree.new_admin_property_path

        fill_in 'property_name', with: 'Vendor property'
        fill_in 'property_presentation', with: 'Vendor property'

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(current_path).to eq spree.admin_properties_path
        expect(Spree::Property.last.vendor_id).to eq vendor.id
      end
    end

    context 'edit' do
      before(:each) do
        within_row(1) { click_icon :edit }
        expect(current_path).to eq spree.edit_admin_property_path(vendor_property)
      end

      scenario 'can update an existing property' do
        fill_in 'property_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      scenario 'shows validation error with blank name' do
        fill_in 'property_name', with: ''
        click_button 'Update'
        expect(page).to have_text 'Name can\'t be blank'
      end
    end
  end
end
