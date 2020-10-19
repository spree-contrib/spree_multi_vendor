require 'rails/generators'
require 'spree/core'

module SpreeMultiVendor
  module Generators
    class MailersPreviewGenerator < Rails::Generators::Base
      desc 'Generates mailers preview for development proposes'

      def self.source_paths
        [
          File.expand_path('templates', __dir__)
        ]
      end

      def copy_mailers_previews
        preview_path = Rails.application.config.action_mailer.preview_path || 'test/mailers/previews'

        template 'mailers/previews/vendor_notification_preview.rb', "#{preview_path}/vendor_notification_preview.rb"
      end
    end
  end
end
