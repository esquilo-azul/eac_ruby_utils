# frozen_string_literal: true

module EacRubyUtils
  class Compact
    ATTRIBUTE_SEPARATOR = '.'

    attr_reader :object, :attributes

    def initialize(object, attributes)
      @object = object
      @attributes = attributes
    end

    # @param attr_path [String, Symbol] A path separated by +ATTRIBUTE_SEPARATOR+.
    # @return [Object]
    def attribute_value(attr_path)
      attr_path.to_s.split(ATTRIBUTE_SEPARATOR).inject(object) do |a, e|
        a.send(e)
      end
    end

    # @return [Array]
    def to_a
      attributes.map { |attr| attribute_value(attr) }
    end

    # @return [Hash]
    def to_h
      attributes.to_h { |attr| [attr.to_sym, attribute_value(attr)] }
    end
  end
end
