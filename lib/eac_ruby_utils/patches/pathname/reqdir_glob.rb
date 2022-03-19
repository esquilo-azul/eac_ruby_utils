# frozen_string_literal: true

require 'pathname'

class Pathname
  # A .glob that raises a ::RuntimeError if +self+ is not a directory.
  # @return [Pathname]
  def reqdir_glob(*args)
    raise ::RuntimeError, "\"#{self}\" is not a directory" unless directory?

    glob(*args)
  end
end
