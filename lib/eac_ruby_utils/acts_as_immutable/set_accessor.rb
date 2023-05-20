# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_immutable/enumerable_accessor'

module EacRubyUtils
  module ActsAsImmutable
    class SetAccessor < ::EacRubyUtils::ActsAsImmutable::EnumerableAccessor
      INITIAL_VALUE = ::Set.new.freeze

      # @param value [Object]
      # @return [Set]
      def immutable_value_set_assert(value)
        return value if value.is_a?(::Set)
        return value.to_set if value.respond_to?(:to_set)

        ::Set.new(value)
      end

      # @return [Set] A empty Set.
      def initial_value
        INITIAL_VALUE
      end
    end
  end
end
