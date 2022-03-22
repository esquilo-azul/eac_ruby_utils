# frozen_string_literal: true

require 'eac_ruby_utils/byte'
require 'eac_ruby_utils/patches/module/compare_by'

module EacRubyUtils
  class ByteArray
    delegate :to_a, :size, :count, :length, :[], :fetch, :map, to: :values_array
    compare_by :values_array

    def initialize(values = [])
      values.each { |value| push(value) }
    end

    def <<(value)
      push(value)
    end

    # @param value [EacRubyUtils::Byte]
    # @return [EacRubyUtils::Byte]
    def push(value)
      values_array.push(::EacRubyUtils::Byte.assert(value))
    end

    # @return [Array<Integer>]
    def to_int_array
      values_array.map(&:to_i)
    end

    private

    def values_array
      @values_array ||= []
    end
  end
end
