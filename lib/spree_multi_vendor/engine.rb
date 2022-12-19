require_relative 'configuration'

module SpreeMultiVendor
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_multi_vendor'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_multi_vendor.environment', before: :load_config_initializers do |_app|
      SpreeMultiVendor::Config = SpreeMultiVendor::Configuration.new
    end

    config.after_initialize do
      ::Spree::PermittedAttributes.product_attributes << :vendor_id if SpreeMultiVendor::Config[:vendorized_models].include?('product')
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    def self.api_v1_available?
      @@api_v1_available ||= Gem::Specification.find_all_by_name('spree_api_v1').any?
    end

    config.to_prepare &method(:activate).to_proc
  end
end
