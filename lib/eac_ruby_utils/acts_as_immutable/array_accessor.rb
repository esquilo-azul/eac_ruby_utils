# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_immutable/enumerable_accessor'

module EacRubyUtils
  module ActsAsImmutable
    class ArrayAccessor < ::EacRubyUtils::ActsAsImmutable::EnumerableAccessor
      INITIAL_VALUE = [].freeze

      # @param value [Object]
      # @return [Array]
      def immutable_value_set_assert(value)
        return value if value.is_a?(::Array)
        return value.to_a if value.respond_to?(:to_a)

        Array(value)
      end

      # @return [Array] A empty array.
      def initial_value
        INITIAL_VALUE
      end
    end
  end
end
