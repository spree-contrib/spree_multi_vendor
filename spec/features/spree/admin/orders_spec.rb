require 'spec_helper'

RSpec.feature 'Admin Orders', :js do
  let(:vendor) { create(:active_vendor, name: 'Vendor') }
  let(:vendor_2) { create(:active_vendor, name: 'Other vendor') }
  let(:order) do
    create(:order,
           line_items: [
             create(:line_item, product: product),
             create(:line_item, product: product_2)
           ])
  end
  let!(:user) { create(:user, vendors: [vendor]) }
  let(:product) { create(:product_in_stock, vendor: vendor) }
  let(:product_2) { create(:product_in_stock, vendor: vendor_2) }

  context 'index' do
    background do
      login_as(user, scope: :spree_user)
    end

    scenario 'shows orders list' do
      visit spree.admin_orders_path

      expect(page).not_to have_text(order.number)
    end
  end

  context 'edit' do
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
