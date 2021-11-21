# frozen_string_literal: true

require 'eac_ruby_utils/common_concern/module_setup'

module EacRubyUtils
  class CompareBy
    attr_reader :fields

    def initialize(fields)
      @fields = fields
    end

    def apply(klass)
      pself = self
      klass.include(::Comparable)
      %i[<=> eql?].each do |cmp_method|
        klass.define_method(cmp_method) do |other|
          pself.object_values(self).send(cmp_method, pself.object_values(other))
        end
      end
      klass.define_method(:hash) { pself.object_values(self).hash }
    end

    def object_values(object)
      fields.map { |field| object.send(field) }
    end
  end
end
