vendor = Spree::Vendor.first_or_initialize do |v|
  v.name = 'Test Vendor'
end
vendor.save!

puts "Created Vendor with the name \"#{vendor.name}\"!"

user = Spree.user_class.where(email: 'user@vendor.com').first_or_initialize do |u|
  u.password = u.password_confirmation = 'vendor123'
end

vendor.users << user unless vendor.users.include?(user)
puts "Created Vendor Admin User with an email \"#{user.email}\" and password \"#{user.password}\"!"