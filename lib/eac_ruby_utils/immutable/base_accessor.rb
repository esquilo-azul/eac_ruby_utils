# frozen_string_literal: true

module EacRubyUtils
  module Immutable
    class BaseAccessor
      common_constructor :name do
        self.name = name.to_sym
      end

      def duplicate_object(object)
        accessor_new_value = yield(immutable_value_get(object))
        new_values = object.send(:immutable_values_get).merge(name => accessor_new_value)
        r = object.class.new(*object.immutable_constructor_args)
        r.send(:immutable_values_set, new_values)
        r
      end

      def immutable_value_get(object)
        object.send(:immutable_values_get)[name]
      end
    end
  end
end
