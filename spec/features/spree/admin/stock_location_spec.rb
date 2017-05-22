require 'spec_helper'

RSpec.feature 'Admin Stock Locations', :js do
  let(:vendor) { create(:vendor) }
  let!(:product) { create(:product, vendor_id: vendor.id, name: 'Test') }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:stock_location) { create(:stock_location, name: 'Test') }

  context 'for user with admin role' do
    context 'index' do
      scenario 'displays all stock locations' do
        login_as(admin, scope: :spree_user)
        visit spree.admin_stock_locations_path
        expect(page).to have_selector('tr', count: 3)
      end
    end
  end

  context 'for user with vendor' do
    before(:each) do
      login_as(user, scope: :spree_user)
      visit spree.admin_stock_locations_path
    end

    context 'index' do
      scenario 'displays only vendor stock location' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    context 'stock movements' do
      scenario 'displays stock movements for vendor stock location' do
        click_on 'Stock Movements'
        expect(page).to have_text 'Stock Movements for Test vendor'
      end

      scenario 'can create a new stock movement for vendor stock location' do
        click_on 'Stock Movements'
        click_on 'New Stock Movement'
        expect(current_path).to eq spree.new_admin_stock_location_stock_movement_path(vendor.stock_locations.first)

        fill_in 'stock_movement_quantity', with: 5
        fill_in 'stock_movement_stock_item_id', with: 1

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(Spree::StockMovement.count).to eq 1
      end
    end

    context 'create' do
      scenario 'can create a new stock location' do
        click_link 'New Stock Location'
        expect(current_path).to eq spree.new_admin_stock_location_path

        fill_in 'stock_location_name', with: 'Vendor stock location'

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(current_path).to eq spree.admin_stock_locations_path
        expect(Spree::StockLocation.last.vendor_id).to eq vendor.id
      end
    end

    context 'edit' do
      before(:each) do
        within_row(1) { click_icon :edit }
        expect(current_path).to eq spree.edit_admin_stock_location_path(vendor.stock_locations.first)
      end

      scenario 'can update an existing stock location' do
        fill_in 'stock_location_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      scenario 'shows validation error with blank name' do
        fill_in 'stock_location_name', with: ''
        click_button 'Update'
        expect(page).to_not have_text 'successfully created!'
      end
    end
  end
end
