sudo apt-get update && sudo apt-get install libvips42
bundle config --local path vendor/bundle
bundle check || bundle install
bundle exec rake test_app
cd spec/dummy && yarn unlink @spree/dashboard
TESTFILES=$(circleci tests glob "spec/**/*_spec.rb" | circleci tests split --split-by=timings)
          bundle exec rspec --format documentation \
                            --format RspecJunitFormatter \
                            -o ~/rspec/rspec.xml \
                            -- ${TESTFILES}