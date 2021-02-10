module SpreeMultiVendor
  VERSION = '2.0.1'

  module_function

  # Returns the version of the currently loaded SpreeMultiVendor as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION
  end
end
