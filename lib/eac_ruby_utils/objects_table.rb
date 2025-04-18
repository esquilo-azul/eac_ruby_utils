# frozen_string_literal: true

require 'eac_ruby_utils/regexp_parser'

module EacRubyUtils
  class ObjectsTable
    BY_PARSER = ::EacRubyUtils::RegexpParser.new(/\Aby_(.+)\z/) do |m|
      BY_PARSER_PARSED_STRUCT.new(m[1], 'by_attribute')
    end
    BY_PARSER_PARSED_STRUCT = ::Struct.new(:attribute, :method_name)

    common_constructor :objects, default: [[]]

    # @param name [String, Symbol]
    # @param value [Object]
    # @return [Object, nil]
    def by_attribute(name, value)
      objects.find { |e| e.send(name) == value }
    end

    # @param name [String, Symbol]
    # @param value [Object]
    # @return [Object]
    def by_attribute!(name, value)
      by_attribute(name, value) ||
        raise(::ArgumentError, "No item found with attribute #{name}=#{value}")
    end

    def respond_to_missing?(method_name, include_private = false)
      super || BY_PARSER.parse?(method_name)
    end

    def method_missing(method_name, *arguments, &block)
      if (parsed = BY_PARSER.parse(method_name))
        return send(parsed.method_name, parsed.attribute, *arguments, &block)
      end

      super
    end
  end
end
