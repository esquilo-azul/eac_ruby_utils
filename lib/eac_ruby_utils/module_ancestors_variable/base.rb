# frozen_string_literal: true

require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module ModuleAncestorsVariable
    class Base
      common_constructor :the_module, :method_name, :initial_value

      # @param current [Object]
      # @param other [Object]
      # @return [Object]
      def merge_operation(current, other)
        current.merge(other)
      end

      # return [Hash]
      def ancestors_variable
        the_module.ancestors.inject(initial_value.dup) do |a, e|
          if e.respond_to?(method_name, true)
            merge_operation(a, e.send(method_name).send(:self_variable))
          else
            a
          end
        end
      end

      # @return [Hash]
      def self_variable
        @self_variable ||= initial_value.dup
      end
    end
  end
end
