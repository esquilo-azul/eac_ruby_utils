# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'ostruct'

module EacRubyUtils
  class OptionsConsumer
    DEFAULT_OPTIONS = { validate: true, ostruct: false }.with_indifferent_access.freeze

    def initialize(data)
      @data = data.with_indifferent_access
    end

    def consume(key, default_value = nil, &block)
      return default_value unless data.key?(key)

      value = data.delete(key)
      value = yield(value) if block
      value
    end

    # If last argument is a Hash it is used a options.
    # Options:
    # * +validate+: validate after consume.
    # * +ostruct+: return a [OpenStruct] instead a [Hash].
    # @return [Hash] (Default) or [OpenStruct].
    def consume_all(*keys)
      options = consume_all_extract_options(keys)
      result = consume_all_build_result(keys, options.fetch(:ostruct))
      validate if options.fetch(:validate)
      result
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

    def consume_all_extract_options(keys)
      options = DEFAULT_OPTIONS
      options = options.merge(keys.pop.with_indifferent_access) if keys.last.is_a?(Hash)
      options
    end

    def consume_all_build_result(keys, ostruct)
      if ostruct
        ::OpenStruct.new(keys.map { |key| [key, consume(key)] }.to_h)
      else
        keys.map { |key| consume(key) }
      end
    end
  end
end
