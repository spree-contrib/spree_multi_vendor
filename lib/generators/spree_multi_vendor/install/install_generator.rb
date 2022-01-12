module SpreeMultiVendor
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_multi_vendor'
      end

      def add_stylesheets
        if File.exists?('vendor/assets/stylesheets/spree/frontend/all.css')
          inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/multi_vendor\n", :before => /\*\//, :verbose => true
        elsif File.exists?('vendor/assets/stylesheets/spree/frontend/all.css.scss')
          append_file 'vendor/assets/stylesheets/spree/frontend/all.css.scss', "\n@import 'spree/multi_vendor'\n"
        elsif File.exists?('vendor/assets/stylesheets/spree/frontend/all.scss')  
          append_file 'vendor/assets/stylesheets/spree/frontend/all.scss', "\n@import 'spree/multi_vendor'\n"
        end
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
