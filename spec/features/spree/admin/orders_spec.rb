require 'spec_helper'

RSpec.feature 'Admin Orders', :js do
  let(:stock) { create(:stock_location_with_items) }
  let(:vendor) { create(:active_vendor, name: 'Vendor') }
  let(:other_vendor) { create(:vendor, name: 'Other vendor') }
  let(:order) do
    create(:order,
           line_items: [
             create(:line_item, product: stock.stock_items.first.product),
             create(:line_item, product: stock.stock_items.last.product)
           ])
  end
  let!(:user) { create(:user, vendors: [vendor]) }

  context 'edit' do
    before do
      stock.stock_items.first.product.update(vendor: vendor)
      stock.stock_items.last.product.update(vendor: other_vendor)
    end

    background do
      login_as(user, scope: :spree_user)
      visit spree.edit_admin_order_path(id: order.number)
    end

    scenario 'vendor can add his product' do
      click_link 'Choose a variant'
      find('.select2-input').fill_in with: 'Product'
      expect(page).to have_text(stock.stock_items.first.product.name)
    end

    scenario 'vendor cannot add other vendors product' do
      click_link 'Choose a variant'
      find('.select2-input').fill_in with: 'Product'
      expect(page).not_to have_text(stock.stock_items.last.product.name)
    end
  end
end
