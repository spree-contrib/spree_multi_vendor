require 'spec_helper'

RSpec.feature 'Admin Shipping Methods', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:shipping_method) { create(:shipping_method, name: 'Test') }
  let!(:vendor_shipping_method) { create(:shipping_method, name: 'Test', vendor: vendor) }

  context 'for user with admin role' do
    context 'index' do
      scenario 'displays all shipping methods' do
        login_as(admin, scope: :spree_user)
        visit spree.admin_shipping_methods_path
        expect(page).to have_selector('tr', count: 3)
      end
    end
  end

  context 'for user with vendor' do
    before(:each) do
      login_as(user, scope: :spree_user)
      visit spree.admin_shipping_methods_path
    end

    context 'index' do
      scenario 'displays only vendor shipping method' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    context 'create' do
      scenario 'can create a new shipping method' do
        click_link 'New Shipping Method'
        expect(current_path).to eq spree.new_admin_shipping_method_path

        fill_in 'shipping_method_name', with: 'Vendor shipping method'
        check Spree::ShippingCategory.last.name

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(current_path).to eq spree.edit_admin_shipping_method_path(Spree::ShippingMethod.last)
        expect(Spree::ShippingMethod.last.vendor_id).to eq vendor.id
      end
    end

    context 'edit' do
      before(:each) do
        within_row(1) { click_icon :edit }
        expect(current_path).to eq spree.edit_admin_shipping_method_path(vendor.shipping_methods.first)
      end

      scenario 'can update an existing shipping method' do
        fill_in 'shipping_method_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      scenario 'shows validation error with blank name' do
        fill_in 'shipping_method_name', with: ''
        click_button 'Update'
        expect(page).to_not have_text 'successfully created!'
      end
    end
  end
end
