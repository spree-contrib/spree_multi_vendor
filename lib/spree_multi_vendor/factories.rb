FactoryGirl.define do
  GEM_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

  Dir[File.join(GEM_ROOT, 'spec', 'factories', '**', '*.rb')].each do |factory|
    require(factory)
  end
end
