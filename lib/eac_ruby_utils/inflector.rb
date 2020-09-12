# frozen_string_literal: true

module EacRubyUtils
  class Inflector
    class << self
      VARIABLE_NAME_PATTERN = /[_a-z][_a-z0-9]*/i.freeze

      def variableize(string)
        r = string.gsub(/[^_a-z0-9]/i, '_').gsub(/_+/, '_').gsub(/_\z/, '').gsub(/\A_/, '').downcase
        m = VARIABLE_NAME_PATTERN.match(r)
        return r if m

        raise ::ArgumentError, "Invalid variable name \"#{r}\" was generated " \
          "from string \"#{string}\""
      end
    end
  end
end
