# frozen_string_literal: true

require 'pathname'

class Pathname
  # Indicate if +self+ is child of +parent_path+.
  #
  # @return [Boolean]
  def child_of?(parent_path)
    self_parts = expand_path.each_filename.to_a
    parent_parts = parent_path.expand_path.each_filename.to_a
    return false if self_parts == parent_parts

    parent_parts.zip(self_parts).all? { |x, y| x == y }
  end
end
