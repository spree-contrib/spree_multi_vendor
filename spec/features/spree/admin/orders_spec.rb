require 'spec_helper'

RSpec.feature 'Admin Orders', :js do
  let(:store) { Spree::Store.default }
  let(:vendor) { create(:active_vendor, name: 'Vendor') }
  let(:vendor_2) { create(:active_vendor, name: 'Other vendor') }
  let(:order) { create(:order, ship_address: create(:address), bill_address: create(:address), store: store) }
  let(:order_2) { create(:order, store: store) }
  let!(:user) { create(:user, vendors: [vendor]) }
  let(:product) { create(:product_in_stock, vendor: vendor, stores:[store]) }
  let(:product_2) { create(:product_in_stock, vendor: vendor_2,stores:[store]) }

  before do
    create(:line_item, order: order, product: product)
    create(:line_item, order: order, product: product_2)
    order.create_proposed_shipments
    order.update(state: :complete, completed_at: Time.current)
    login_as(user, scope: :spree_user)
  end

  shared_examples 'shows order data' do
    it { expect(page).to have_text(order.number) }
    it { expect(page).to have_content(order.display_vendor_total(vendor).to_html) }
  end

  context 'index' do
    background do
      visit spree.admin_orders_path
    end

    it_behaves_like 'shows order data'

    it 'does not show non-vendor orders' do
      expect(page).not_to have_text(order_2.number)
    end
  end

  context 'cart' do
    background do
      visit spree.cart_admin_order_path(id: order.number)
    end

    it_behaves_like 'shows order data'
  end

  context 'customer info' do
    background do
      visit spree.admin_order_customer_path(order_id: order.number)
    end

    it_behaves_like 'shows order data'

    it 'shows customer information' do
      expect(page).to have_text(order.ship_address.full_name)
      expect(page).to have_text(order.ship_address.address1)
      expect(page).to have_text(order.ship_address.city)

      expect(page).to have_text(order.bill_address.full_name)
      expect(page).to have_text(order.bill_address.address1)
      expect(page).to have_text(order.bill_address.city)

      expect(page).not_to have_selector('input[type=text]')
    end
  end

  context 'edit' do
    background do
      visit spree.edit_admin_order_path(id: order.number)
    end

    it_behaves_like 'shows order data'

    scenario 'vendor can add his product' do
      select2_open label: 'Name or SKU'
      select2_search product.name, from: 'Name or SKU'
      select2_select product.name, from: 'Name or SKU', match: :first
      expect(page).to have_text(product.name)
    end

    scenario 'vendor cannot add other vendors product' do
      select2_open label: 'Name or SKU'
      select2_search product_2.name, from: 'Name or SKU'
      expect(page).not_to have_text(product_2.name)
    end
  end
end
