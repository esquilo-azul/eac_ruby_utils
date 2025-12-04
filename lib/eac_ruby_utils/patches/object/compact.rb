# frozen_string_literal: true

require 'eac_ruby_utils/compact'

class Object
  # @return [EacRubyUtils::Compact]
  def to_compact(*attributes)
    ::EacRubyUtils::Compact.new(self, attributes)
  end

  # @return [Array]
  def compact_to_a(*attributes)
    to_compact(*attributes).to_a
  end

  # @return [Hash]
  def compact_to_h(*attributes)
    to_compact(*attributes).to_h
  end
end
