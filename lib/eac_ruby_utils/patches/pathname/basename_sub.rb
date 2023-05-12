# frozen_string_literal: true

require 'pathname'

class Pathname
  # @param suffix [String]
  # @return [Pathname]
  def basename_sub(suffix = '')
    new_basename = basename(suffix)
    new_basename = yield(new_basename) if block_given?
    parent.join(new_basename)
  end
end
