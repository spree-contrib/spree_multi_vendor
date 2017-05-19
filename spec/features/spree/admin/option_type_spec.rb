require 'spec_helper'

RSpec.feature 'Admin Option Types', :js do
  let(:vendor) { create(:vendor) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let!(:admin) { create(:admin_user) }
  let!(:option_type) { create(:option_type, name: 'Test1') }
  let!(:vendor_option_type) { create(:option_type, vendor_id: vendor.id, name: 'Test2') }

  context 'for user with admin role' do
    context 'index' do
      scenario 'displays all option types' do
        login_as(admin, scope: :spree_user)
        visit spree.admin_option_types_path
        expect(page).to have_selector('tr', count: 3)
      end
    end
  end

  context 'for user with vendor' do
    before(:each) do
      login_as(user, scope: :spree_user)
      visit spree.admin_option_types_path
    end

    context 'index' do
      scenario 'displays only vendor option type' do
        expect(page).to have_selector('tr', count: 2)
      end
    end

    context 'create' do
      scenario 'can create a new option type' do
        click_link 'New Option Type'
        expect(current_path).to eq spree.new_admin_option_type_path

        fill_in 'option_type_name', with: 'Vendor option type'
        fill_in 'option_type_presentation', with: 'Vendor option type'

        click_button 'Create'

        expect(page).to have_text 'successfully created!'
        expect(current_path).to eq spree.edit_admin_option_type_path(Spree::OptionType.last)
        expect(Spree::OptionType.last.vendor_id).to eq vendor.id
      end
    end

    context 'edit' do
      before(:each) do
        within_row(1) { click_icon :edit }
        expect(current_path).to eq spree.edit_admin_option_type_path(vendor_option_type)
      end

      scenario 'can update an existing option type' do
        fill_in 'option_type_name', with: 'Testing edit'
        click_button 'Update'
        expect(page).to have_text 'successfully updated!'
        expect(page).to have_text 'Testing edit'
      end

      scenario 'shows validation error with blank name' do
        fill_in 'option_type_name', with: ''
        click_button 'Update'
        expect(page).to have_text 'Name can\'t be blank'
      end
    end
  end
end
