# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'

module EacRubyUtils
  class OptionsConsumer
    def initialize(data)
      @data = data.with_indifferent_access
    end

    def consume(key, default_value = nil, &block)
      return default_value unless data.key?(key)

      value = data.delete(key)
      value = yield(value) if block
      value
    end

    def validate
      return if data.empty?

      raise "Invalid keys: #{data.keys}"
    end

    def left_data
      data.dup
    end

    private

    attr_reader :data
  end
end
