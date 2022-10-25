# frozen_string_literal: true

require 'eac_ruby_utils/boolean'

class Object
  # Shortcut to +EacRubyUtils::Boolean.parse(self).
  #
  # @return [Boolean]
  def to_bool
    ::EacRubyUtils::Boolean.parse(self)
  end
end
