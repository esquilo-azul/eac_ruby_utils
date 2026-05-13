# frozen_string_literal: true

require 'eac_ruby_utils/recursive_builder'

class Object
  # Equivalent to +EacRubyUtils::RecursiveBuilder.new(self, &neighbors_block).result+.
  # @param &neighbors_block [Proc]
  # @return [Enumerable]
  def recursive_build(&)
    ::EacRubyUtils::RecursiveBuilder.new(self, &).result
  end
end
