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
  let(:product) { stock.stock_items.first.product }
  let(:product_2) { stock.stock_items.last.product }

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
      select2_open label: 'Name or SKU'
      select2_search product.name, from: 'Name or SKU'
      select2_select product.name, from: 'Name or SKU', match: :first
      expect(page).to have_text(product.name)
    end

    scenario 'vendor cannot add other vendors product' do
      select2_open label: 'Name or SKU'
      select2_search product.name, from: 'Name or SKU'
      expect(page).not_to have_text(product.name)
    end
  end
end
