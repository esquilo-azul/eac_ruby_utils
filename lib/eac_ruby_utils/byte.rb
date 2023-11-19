# frozen_string_literal: true

require 'eac_ruby_utils/bit'
require 'eac_ruby_utils/bit_array'
require 'eac_ruby_utils/patches/module/compare_by'

module EacRubyUtils
  class Byte
    ASSEMBLY_HEXADECIMAL_PREFIX = '$'
    BIT_COUNT = 8
    BIT_INDEX_RANGE = (0..7).freeze
    VALUE_RANGE = (0..255).freeze

    class << self
      def assert(obj)
        return obj if obj.is_a?(self)

        new(obj.to_i)
      end

      def from_bit_array(bit_array, big_endian = false) # rubocop:disable Style/OptionalBooleanParameter
        bit_array = ::EacRubyUtils::BitArray.assert(bit_array)
        raise ::ArgumentError, "Wrong bit array size: #{bit_array.size}" if
        bit_array.size != BIT_COUNT

        bit_array = bit_array.reverse if big_endian
        bit_array.each_with_index.inject(new(0)) do |a, e|
          a.bit_set(e[1], e[0])
        end
      end

      def valid_bit_index?(value)
        value.is_a?(::Integer) && BIT_INDEX_RANGE.include?(value)
      end

      def validate_bit_index(value)
        return value if valid_bit_index?(value)

        raise(::ArgumentError, "Invalid bit index: #{value} (Range: #{BIT_INDEX_RANGE})")
      end

      def valid_value?(value)
        value.is_a?(::Integer) && VALUE_RANGE.include?(value)
      end

      def validate_value(value)
        return value if valid_value?(value)

        raise(::ArgumentError, "Invalid byte value: #{value} (Range: #{VALUE_RANGE})")
      end
    end

    attr_reader :value

    compare_by :value

    def initialize(value)
      self.value = value
    end

    # @param bit_index [Integer]
    # @return [EacRubyUtils::Bit]
    def [](bit_index)
      bit_get(bit_index)
    end

    # @param bit_index [Integer]
    # @return [EacRubyUtils::Bit]
    def bit_get(bit_index)
      self.class.validate_bit_index(bit_index)

      ::EacRubyUtils::Bit.new((value & (1 << bit_index)) >> bit_index)
    end

    def bit_set(bit_index, bit_value)
      self.class.validate_bit_index(bit_index)
      bit = ::EacRubyUtils::Bit.assert(bit_value)
      mask = (1 << bit_index)
      self.class.new(bit.zero? ? value & ~mask : value | mask)
    end

    # @return [EacRubyUtils::BitArray]
    def to_bit_array(range = BIT_INDEX_RANGE)
      ::EacRubyUtils::BitArray.new(range.map { |bit_index| self[bit_index] })
    end

    # @return [Integer]
    def to_i
      value
    end

    # @return [String]
    def to_asm_hex
      ASSEMBLY_HEXADECIMAL_PREFIX + to_hex
    end

    # @return [String]
    def to_hex
      value.to_s(16).upcase.rjust(2, '0')
    end

    private

    attr_writer :value
  end
end
