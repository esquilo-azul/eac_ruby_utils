# frozen_string_literal: true

require 'eac_ruby_utils/inflector'

class String
  # Shortcut to `EacRubyUtils::Inflector.variableize(self, ...)`.
  # @see EacRubyUtils::Inflector.variableize
  def variableize(validate = true) # rubocop:disable Style/OptionalBooleanParameter
    ::EacRubyUtils::Inflector.variableize(self, validate)
  end
end
