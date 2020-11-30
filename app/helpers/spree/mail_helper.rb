module Spree
  module MailHelper
    def variant_image_url(variant)
      image = default_image_for_product_or_variant(variant)
      image ? main_app.url_for(image.url(:small)) : 'noimage/small.png'
    end

    def default_image_for_product_or_variant(product_or_variant)
      Rails.cache.fetch("spree/default-image/#{product_or_variant.cache_key_with_version}") do
        if product_or_variant.is_a?(Spree::Product)
          default_image_for_product(product_or_variant)
        elsif product_or_variant.is_a?(Spree::Variant)
          if product_or_variant.images.any?
            product_or_variant.images.first
          else
            default_image_for_product(product_or_variant.product)
          end
        end
      end
    end

    # we should always try to render image of the default variant
    # same as it's done on PDP
    def default_image_for_product(product)
      if product.images.any?
        product.images.first
      elsif product.default_variant.images.any?
        product.default_variant.images.first
      elsif product.variant_images.any?
        product.variant_images.first
      end
    end

    def logo_path
      return default_logo unless store_logo.attached?
      return main_app.url_for(store_logo.variant(resize: '244x104>')) if store_logo.variable?

      return main_app.url_for(store_logo) if store_logo.image?
    end

    def name_for(order)
      order.name || Spree.t('customer')
    end

    def store_logo
      @order&.store&.mailer_logo || @order&.store&.logo || current_store.mailer_logo || current_store.logo
    end

    def default_logo
      Spree::Config.mailer_logo || Spree::Config.logo
    end
  end
end
