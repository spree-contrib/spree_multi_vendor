module Spree
  class VendorUser < Spree::Base
    belongs_to :vendor, class_name: 'Spree::Vendor', required: Spree.version.to_f >= 3.5
    belongs_to :user, class_name: Spree.user_class.name, required: Spree.version.to_f >= 3.5

    validates :vendor_id, uniqueness: { scope: :user_id }

    before_save :set_vendor_notification_email

    def set_vendor_notification_email
      return if vendor&.notification_email.present? || !vendor&.users&.empty?

      vendor.update_notification_email(user.email)
    end
  end
end
