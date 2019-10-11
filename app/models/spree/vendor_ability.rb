class Spree::VendorAbility
  include CanCan::Ability

  def initialize(user)
    @vendor_ids = user.vendors.active.ids

    if @vendor_ids.any?
      apply_classifications_permissions
      apply_order_permissions
      apply_image_permissions
      apply_option_type_permissions
      apply_price_permissions
      apply_product_option_type_permissions
      apply_product_permissions
      apply_product_properties_permissions
      apply_properties_permissions
      apply_shipment_permissions
      apply_shipping_methods_permissions
      apply_stock_permissions
      apply_stock_item_permissions
      apply_stock_location_permissions
      apply_stock_movement_permissions
      apply_variant_permissions
      apply_vendor_permissions
      apply_vendor_settings_permissions
      apply_state_changes_permissions
    end
  end

  private

  def apply_classifications_permissions
    can :manage, Spree::Classification, product: { vendor_id: @vendor_ids }
  end

  def apply_order_permissions
    cannot :create, Spree::Order
    can [:admin, :index, :edit, :update, :cart], Spree::Order, line_items: { product: { vendor_id: @vendor_ids } }
  end

  def apply_image_permissions
    can :create, Spree::Image

    can [:manage, :modify], Spree::Image do |image|
      image.viewable_type == 'Spree::Variant' && @vendor_ids.include?(image.viewable.vendor_id)
    end
  end

  def apply_option_type_permissions
    cannot_display_model(Spree::OptionType)
    can :manage, Spree::OptionType, vendor_id: @vendor_ids
    can :create, Spree::OptionType
  end

  def apply_price_permissions
    can :modify, Spree::Price, variant: { vendor_id: @vendor_ids }
  end

  def apply_product_option_type_permissions
    can :modify, Spree::ProductOptionType, product: { vendor_id: @vendor_ids }
  end

  def apply_product_permissions
    cannot_display_model(Spree::Product)
    can :manage, Spree::Product, vendor_id: @vendor_ids
    can :create, Spree::Product
  end

  def apply_properties_permissions
    cannot_display_model(Spree::Property)
    can :manage, Spree::Property, vendor_id: @vendor_ids
    can :create, Spree::Property
  end

  def apply_product_properties_permissions
    cannot_display_model(Spree::ProductProperty)
    can :manage, Spree::ProductProperty, property: { vendor_id: @vendor_ids }
  end

  def apply_shipment_permissions
    can :update, Spree::Shipment, inventory_units: { line_item: { product: { vendor_id: @vendor_ids } } }
  end

  def apply_shipping_methods_permissions
    can :manage, Spree::ShippingMethod, vendor_id: @vendor_ids
    can :create, Spree::ShippingMethod
  end

  def apply_stock_permissions
    can :admin, Spree::Stock
  end

  def apply_stock_item_permissions
    can [:admin, :modify, :read], Spree::StockItem, stock_location: { vendor_id: @vendor_ids }
  end

  def apply_stock_location_permissions
    can :manage, Spree::StockLocation, vendor_id: @vendor_ids
    can :create, Spree::StockLocation
  end

  def apply_stock_movement_permissions
    can :create, Spree::StockMovement
    can :manage, Spree::StockMovement, stock_item: { stock_location: { vendor_id: @vendor_ids } }
  end

  def apply_variant_permissions
    can :manage, Spree::Variant, vendor_id: @vendor_ids
    can :create, Spree::Variant
  end

  def apply_vendor_permissions
    can [:admin, :update], Spree::Vendor, id: @vendor_ids
  end

  def apply_vendor_settings_permissions
    can :manage, :vendor_settings
  end

  def apply_state_changes_permissions
    can [:admin, :index], Spree::StateChange do |state_change|
      (@vendor_ids & state_change.user.vendor_ids).any?
    end
  end

  def cannot_display_model(model)
    Spree.version.to_f < 4.0 ? (cannot :display, model) : (cannot :read, model)
  end
end
