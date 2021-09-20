# frozen_string_literal: true

require 'eac_ruby_utils/compact'

class Object
  # @return [EacRubyUtils::Compact]
  def compact(*attributes)
    ::EacRubyUtils::Compact.new(self, attributes)
  end

  # @return [Array]
  def compact_to_a(*attributes)
    compact(*attributes).to_a
  end

  # @return [Hash]
  def compact_to_h(*attributes)
    compact(*attributes).to_h
  end
end
