module SpreeMultiVendor
  module_function

  # Returns the version of the currently loaded SpreeMultiVendor as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 2
    MINOR = 0
    TINY  = 0
    PRE   = 'beta'

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
