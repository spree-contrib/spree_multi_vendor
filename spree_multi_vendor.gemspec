# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_multi_vendor/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_multi_vendor'
  s.version     = SpreeMultiVendor.version
  s.summary     = 'Spree Commerce multi vendor marketplace extension'
  s.description = 'Spree Commerce multi vendor marketplace extension'
  s.required_ruby_version = '>= 3.0'

  s.author    = 'Spark Solutions'
  s.email     = 'we@sparksolutions.co'
  s.homepage  = 'https://spreecommerce.org/use-cases/multi-vendor-marketplace-demo/'
  s.license = 'BSD-3-Clause'

  s.metadata = {
    'bug_tracker_uri'   => 'https://github.com/spree-contrib/spree_multi_vendor/issues',
    'changelog_uri'     => "https://github.com/spree-contrib/spree_multi_vendor/releases/tag/v#{s.version}",
    'documentation_uri' => 'https://guides.spreecommerce.org/',
    'source_code_uri'   => "https://github.com/spree-contrib/spree_multi_vendor/tree/v#{s.version}",
  }

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '>= 4.7.0'
  s.add_dependency 'spree', spree_version
  s.add_dependency 'spree_backend', spree_version
  s.add_dependency 'spree_emails', spree_version
  s.add_dependency 'spree_extension'

  s.add_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spree_dev_tools'
end
