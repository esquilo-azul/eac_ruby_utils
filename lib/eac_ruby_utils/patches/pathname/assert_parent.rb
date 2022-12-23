# frozen_string_literal: true

require 'pathname'

class Pathname
  # Invoke +mkpath+ for parent path and return +self+.
  # @return [self]
  def assert_parent
    parent.mkpath
    self
  end
end
