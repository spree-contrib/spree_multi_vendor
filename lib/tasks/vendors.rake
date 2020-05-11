namespace :spree_multi_vendor do
  namespace :sample do
    desc 'Create sample Vendor and Vendor User'
    task create: :environment do
      require File.join(File.dirname(__FILE__), '..', '..', 'db', 'default', 'vendors.rb')
    end
  end
end