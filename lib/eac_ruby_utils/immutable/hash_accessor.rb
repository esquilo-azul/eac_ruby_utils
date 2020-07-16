# frozen_string_literal: true

require 'eac_ruby_utils/immutable/base_accessor'
require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module Immutable
    class HashAccessor < ::EacRubyUtils::Immutable::BaseAccessor
      def apply(klass)
        apply_get(klass)
        apply_set(klass)
      end

      def immutable_value_get(object)
        super || {}
      end

      def immutable_value_set(object, key, value)
        duplicate_object(object) do |old_value|
          (old_value || {}).merge(key => value)
        end
      end

      private

      def apply_get(klass)
        accessor = self
        klass.send(:define_method, ::ActiveSupport::Inflector.pluralize(name)) do
          accessor.immutable_value_get(self)
        end
      end

      def apply_set(klass)
        accessor = self
        klass.send(:define_method, name) do |*args|
          case args.count
          when 1 then next accessor.immutable_value_get(self, args[0])
          when 2 then next accessor.immutable_value_set(self, *args[0..1])
          else
            raise ::ArgumentError, "wrong number of arguments (given #{args.count}, expected 1..2)"
          end
        end
      end
    end
  end
end
