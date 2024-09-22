sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4EB27DB2A3B88B8B
sudo apt-get update && sudo apt-get install libvips
bundle config --local path vendor/bundle
bundle check || bundle install