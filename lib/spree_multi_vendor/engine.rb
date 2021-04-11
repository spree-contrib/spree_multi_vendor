module SpreeMultiVendor
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_multi_vendor'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_multi_vendor.environment', before: :load_config_initializers do |_app|
      SpreeMultiVendor::Config = SpreeMultiVendor::Configuration.new
    end

    def self.activate
      ['app', 'lib'].each do |dir|
        Dir.glob(File.join(File.dirname(__FILE__), "../../#{dir}/**/*_decorator*.rb")) do |c|
          Rails.application.config.cache_classes ? require(c) : load(c)
        end
      end

      Spree::Frontend::Config[:products_filters] = %w(keywords price sort_by vendors)
      Spree::Frontend::Config[:additional_filters_partials] = %w(vendors)
      Spree::Config.searcher_class = Spree::Search::MultiVendor
      ApplicationController.send :include, SpreeMultiVendor::MultiVendorHelpers
    end

    config.to_prepare &method(:activate).to_proc
  end
end