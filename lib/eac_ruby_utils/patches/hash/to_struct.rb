# frozen_string_literal: true

require 'eac_ruby_utils/struct'

class Hash
  # Returns an <tt>EacRubyUtils::Struct</tt> out of its receiver.
  def to_struct
    ::EacRubyUtils::Struct.new(self)
  end
end
