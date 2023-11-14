module SpreeMultiVendor
  class Configuration
    DEFAULT_VENDORIZED_MODELS ||= %w[product variant stock_location shipping_method].freeze

    attr_accessor :vendorized_models

    def initialize
      self.vendorized_models = DEFAULT_VENDORIZED_MODELS
    end

    def configure
      yield(self) if block_given?
    end

    def get(preference)
      send(preference)
    end

    alias [] get

    def set(preference, value)
      send("#{preference}=", value)
    end

    alias []= set
  end
end
