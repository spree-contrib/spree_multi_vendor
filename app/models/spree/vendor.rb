module Spree
  class Vendor < Spree::Base
    extend FriendlyId

    acts_as_paranoid
    acts_as_list column: :priority
    friendly_id :name, use: %i[slugged history]

    validates :name,
      presence: true,
      uniqueness: { case_sensitive: false },
      format: { with: /\A[A-Za-z0-9\ ]+\z/, message: Spree.t('only_alphanumeric_chars') }

    validates :slug, uniqueness: true
    if Spree.version.to_f >= 3.6
      validates_associated :image
    end
    validates :notification_email, email: true, allow_blank: true

    with_options dependent: :destroy do
      if Spree.version.to_f >= 3.6
        has_one :image, as: :viewable, dependent: :destroy, class_name: 'Spree::VendorImage'
      end
      has_many :commissions, class_name: 'Spree::OrderCommission'
      has_many :option_types
      has_many :products
      has_many :properties
      has_many :shipping_methods
      has_many :stock_locations
      has_many :variants
      has_many :vendor_users
      has_many :images, -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: 'Spree::Image'
      has_many :vendor_calenders
      has_many :calenders, through: :vendor_calenders
    end

    has_many :users, through: :vendor_users

    after_create :create_stock_location
    after_update :update_stock_location_names

    state_machine :state, initial: :pending do
      event :activate do
        transition to: :active
      end

      event :block do
        transition to: :blocked
      end
    end

    scope :active, -> { where(state: 'active') }

    self.whitelisted_ransackable_attributes = %w[name state]

    def update_notification_email(email)
      update(notification_email: email)
    end

    private

    def create_stock_location
      stock_locations.where(name: name, country: Spree::Country.default).first_or_create!
    end

    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end

    def update_stock_location_names
      if (Spree.version.to_f < 3.5 && self.name_changed?) || (Spree.version.to_f >= 3.5 && saved_changes&.include?(:name))
        stock_locations.update_all({ name: name })
      end
    end
  end
end
