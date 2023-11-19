# frozen_string_literal: true

module EacRubyUtils
  class Compact
    attr_reader :object, :attributes

    def initialize(object, attributes)
      @object = object
      @attributes = attributes
    end

    # @return [Array]
    def to_a
      attributes.map { |attr| object.send(attr) }
    end

    # @return [Hash]
    def to_h
      attributes.to_h { |attr| [attr.to_sym, object.send(attr)] }
    end
  end
end
