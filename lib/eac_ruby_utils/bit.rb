# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/compare_by'

module EacRubyUtils
  class Bit
    VALID_VALUES = [0, 1].freeze

    class << self
      def assert(obj)
        return obj if obj.is_a?(self)

        new(obj.to_i)
      end

      def valid_integer?(value)
        value.is_a?(::Integer) && VALID_VALUES.include?(value)
      end

      def validate_integer(value)
        return value if valid_integer?(value)

        raise(::ArgumentError, "Invalid bit value: #{value} (Valid: #{VALID_VALUES})")
      end
    end

    attr_reader :value

    compare_by :value
    delegate :to_s, :zero?, to: :value

    # @param value [Integer]
    def initialize(value)
      @value = self.class.validate_integer(value)
    end

    # @return [Boolean]
    def one?
      !zero?
    end

    # @return [Integer]
    def to_i
      value
    end
  end
end
