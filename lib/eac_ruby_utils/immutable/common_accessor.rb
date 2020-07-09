# frozen_string_literal: true

require 'eac_ruby_utils/immutable/base_accessor'
require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module Immutable
    class CommonAccessor < ::EacRubyUtils::Immutable::BaseAccessor
      def apply(klass)
        accessor = self
        klass.send(:define_method, name) do |*args|
          case args.count
          when 0 then next accessor.immutable_value_get(self)
          when 1 then next accessor.immutable_value_set(self, args.first)
          else
            raise ::ArgumentError, "wrong number of arguments (given #{args.count}, expected 0..1)"
          end
        end
      end

      def immutable_value_get(object)
        object.send(:immutable_values_get)[name]
      end

      def immutable_value_set(object, value)
        duplicate_object(object) { |_old_value| value }
      end
    end
  end
end
