# frozen_string_literal: true

module EacRubyUtils
  class Compact
    attr_reader :object, :attributes

    def initialize(object, attributes)
      @object = object
      @attributes = attributes
    end

    # @param attr [Symbol]
    # @return [Object]
    def attribute_value(attr)
      object.send(attr)
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
