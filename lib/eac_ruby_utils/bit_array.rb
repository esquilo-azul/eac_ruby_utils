# frozen_string_literal: true

require 'eac_ruby_utils/bit'
require 'eac_ruby_utils/byte'
require 'eac_ruby_utils/byte_array'
require 'eac_ruby_utils/patches/module/compare_by'

module EacRubyUtils
  class BitArray
    class << self
      def assert(obj)
        return obj if obj.is_a?(self)
        return new(obj) if obj.is_a?(::Enumerable)

        raise "Could not convert #{obj} to #{self}"
      end
    end

    delegate :each, :each_with_index, :to_a, :size, :count, :length, :[], :fetch, to: :values_array
    compare_by :values_array

    def initialize(values = [])
      values.each { |value| push(value) }
    end

    def <<(value)
      push(value)
    end

    # @param value [EacRubyUtils::Bit]
    # @return [EacRubyUtils::Bit]
    def push(value)
      values_array.push(::EacRubyUtils::Bit.assert(value))
    end

    # @return [EacRubyUtils::BitArray]
    def reverse
      self.class.new(values_array.reverse)
    end

    # @param big_endian [Boolean]
    # @return [EacRubyUtils::ByteArray]
    def to_byte_array(big_endian = false)
      unless count.modulo(::EacRubyUtils::Byte::BIT_COUNT).zero?
        raise 'Bits returned is not multile of 8'
      end

      byte_bits_enumerator.each_with_object(::EacRubyUtils::ByteArray.new) do |e, a|
        a << ::EacRubyUtils::Byte.from_bit_array(e, big_endian)
      end
    end

    # @return [Array<Integer>]
    def to_int_array
      values_array.map(&:to_i)
    end

    private

    def byte_bits_enumerator
      ::Enumerator.new do |y|
        offset = 0
        while offset < values_array.count
          y.yield(values_array.slice(offset, ::EacRubyUtils::Byte::BIT_COUNT))
          offset += ::EacRubyUtils::Byte::BIT_COUNT
        end
      end
    end

    def values_array
      @values_array ||= []
    end
  end
end
