# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/acts_as_immutable/base_accessor'
require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module ActsAsImmutable
    class ArrayAccessor < ::EacRubyUtils::ActsAsImmutable::BaseAccessor
      def apply(klass)
        apply_singular(klass)
        apply_plural(klass)
      end

      def apply_plural(klass)
        accessor = self
        klass.send(:define_method, ::ActiveSupport::Inflector.pluralize(name)) do |*args|
          case args.count
          when 0 then next accessor.immutable_value_get_filtered(self)
          when 1 then next accessor.immutable_value_set_filtered(self, args.first)
          else
            raise ::ArgumentError, "wrong number of arguments (given #{args.count}, expected 0..1)"
          end
        end
      end

      def apply_singular(klass)
        accessor = self
        klass.send(:define_method, name) do |value|
          accessor.immutable_value_push(self, value)
        end
      end

      def immutable_value_get(object)
        super || []
      end

      def immutable_value_push(object, value)
        duplicate_object(object) do |old_value|
          (old_value || []) + [value]
        end
      end

      def immutable_value_set(object, value)
        duplicate_object(object) { |_old_value| value }
      end
    end
  end
end
