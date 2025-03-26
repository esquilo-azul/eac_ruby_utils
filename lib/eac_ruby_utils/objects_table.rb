# frozen_string_literal: true

require 'eac_ruby_utils/regexp_parser'

module EacRubyUtils
  class ObjectsTable
    BY_PARSER = ::EacRubyUtils::RegexpParser.new(/\Aby_(.+)\z/) { |m| m[1] }

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
      if (attribute = BY_PARSER.parse(method_name))
        return by_attribute(attribute, *arguments, &block)
      end

      super
    end
  end
end
