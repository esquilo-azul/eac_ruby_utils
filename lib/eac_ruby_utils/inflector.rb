# frozen_string_literal: true

require 'active_support/inflector'

module EacRubyUtils
  class Inflector
    class << self
      VARIABLE_NAME_PATTERN = /[_a-z][_a-z0-9]*/i.freeze

      # Convert a string to a variable format: first character as a lowercase letter or underscore
      # and other as a lowercase letter, underscore or numbers.
      # @param string [String] The source string.
      # @param validate [Boolean] Affect the outcome when the result builded is not in a valid
      #   variable format. If `true`, it raises a {ArgumentError}. If `false`, return `nil`.
      # @return [String, nil]
      # @raise [ArgumentError]
      def variableize(string, validate = true)
        r = ::ActiveSupport::Inflector.transliterate(string).gsub(/[^_a-z0-9]/i, '_')
              .gsub(/_+/, '_').gsub(/_\z/, '').gsub(/\A_/, '').downcase
        m = VARIABLE_NAME_PATTERN.match(r)
        return r if m
        return nil unless validate

        raise ::ArgumentError, "Invalid variable name \"#{r}\" was generated " \
          "from string \"#{string}\""
      end
    end
  end
end
