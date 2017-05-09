FactoryGirl.define do
  Dir[Dir.pwd + '/spec/factories/**/*.rb'].each do |factory|
    require File.expand_path(factory)
  end
end
