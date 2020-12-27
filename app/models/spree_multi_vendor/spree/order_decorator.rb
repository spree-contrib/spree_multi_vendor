module SpreeMultiVendor::Spree::OrderDecorator
  def self.prepended(base)
    base.has_many :commissions, class_name: 'Spree::OrderCommission'
    base.state_machine.after_transition to: :complete, do: :generate_order_commissions
    base.state_machine.after_transition to: :complete, do: :send_notification_mails_to_vendors
  end

  def generate_order_commissions
    Spree::Orders::GenerateCommissions.call(order: self)
  end

  def vendor_line_items(vendor)
    line_items.for_vendor(vendor)
  end

  def vendor_shipments(vendor)
    shipments.for_vendor(vendor)
  end

  def vendor_ship_total(vendor)
    vendor_shipments(vendor).sum(&:final_price)
  end

  def vendor_subtotal(vendor)
    vendor_line_items(vendor).sum(&:total)
  end

  def vendor_promo_total(vendor)
    vendor_line_items(vendor).sum(:promo_total) + vendor_shipments(vendor).sum(:promo_total)
  end

  def vendor_additional_tax_total(vendor)
    vendor_line_items(vendor).sum(:additional_tax_total) + vendor_shipments(vendor).sum(:additional_tax_total)
  end

  def vendor_included_tax_total(vendor)
    vendor_line_items(vendor).sum(:included_tax_total) + vendor_shipments(vendor).sum(:included_tax_total)
  end

  def vendor_pre_tax_item_amount(vendor)
    vendor_line_items(vendor).sum(:pre_tax_amount)
  end

  def vendor_pre_tax_ship_amount(vendor)
    vendor_shipments(vendor).sum(:pre_tax_amount)
  end

  def vendor_pre_tax_total(vendor)
    vendor_line_items(vendor).sum(:pre_tax_amount) + vendor_shipments(vendor).sum(:pre_tax_amount)
  end

  def vendor_item_count(vendor)
    vendor_line_items(vendor).sum(:quantity)
  end

  def vendor_total(vendor)
    vendor_line_items(vendor).sum(&:total) + vendor_ship_total(vendor)
  end

  def display_order_commission
    Spree::Money.new(commissions.sum(:amount), { currency: currency })
  end

  def vendor_commission(vendor)
    commissions.for_vendor(vendor).sum(:amount)
  end

  # money methods
  METHOD_NAMES = %w[
    total ship_total subtotal included_tax_total additional_tax_total promo_total
    pre_tax_item_amount pre_tax_ship_amount pre_tax_total commission
  ].freeze

  METHOD_NAMES.each do |method_name|
    define_method("display_vendor_#{method_name}") do |vendor|
      Spree::Money.new(send("vendor_#{method_name}", vendor), { currency: currency })
    end
  end

  def send_notification_mails_to_vendors
    vendor_ids.each do |vendor_id|
      Spree::VendorMailer.vendor_notification_email(id, vendor_id).deliver_later
    end
  end

  # we're leaving this on purpose so it can be easily modified to fit desired scenario
  # eg. scenario A - vendorized products, scenario B - vendorized variants of the same products
  def vendor_ids
    @vendor_ids ||= line_items.map { |line_item| line_item.product.vendor_id }.uniq.compact
  end

  def vendor_list
    @vendor_list ||= line_items.map { |line_item| line_item.product.vendor }.uniq
  end

  def vendor_totals
    return if vendor_list.none?

    vendor_list.map do |vendor|
      Spree::VendorOrderTotals.new(vendor: vendor, order: self)
    end
  end
end

Spree::Order.prepend SpreeMultiVendor::Spree::OrderDecorator
