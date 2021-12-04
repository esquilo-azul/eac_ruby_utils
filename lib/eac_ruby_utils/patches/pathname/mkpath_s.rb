# frozen_string_literal: true

require 'pathname'

class Pathname
  # Execute .mkpath and return +self+.
  # @return [Pathname]
  def mkpath_s
    mkpath
    self
  end
end
