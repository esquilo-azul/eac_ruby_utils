# frozen_string_literal: true

require 'eac_ruby_utils/patches/object/if_respond'

module EacRubyUtils
  module ActsAsImmutable
    class BaseAccessor
      FILTER_GET_METHOD_NAME_FORMAT = '%s_get_filter'

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

      # @param object [Object]
      # @return [Object]
      def immutable_value_get_filtered(object)
        r = immutable_value_get(object)
        if object.respond_to?(immutable_value_get_filtered_method_name, true)
          r = object.send(immutable_value_get_filtered_method_name, r)
        end
        r
      end

      # @return [Symbol]
      def immutable_value_get_filtered_method_name
        format(FILTER_GET_METHOD_NAME_FORMAT, name)
      end
    end
  end
end
