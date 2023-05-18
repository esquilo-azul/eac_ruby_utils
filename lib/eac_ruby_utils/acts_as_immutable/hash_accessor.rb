# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_immutable/base_accessor'
require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module ActsAsImmutable
    class HashAccessor < ::EacRubyUtils::ActsAsImmutable::BaseAccessor
      def apply(klass)
        apply_plural(klass)
        apply_singular(klass)
      end

      def immutable_value_get(object)
        super || {}
      end

      def immutable_value_get_single(object, key)
        immutable_value_get(object)[key]
      end

      def immutable_value_set(object, new_hash)
        duplicate_object(object) { |_old_value| new_hash }
      end

      def immutable_value_set_single(object, key, value)
        immutable_value_set(object, immutable_value_get(object).merge(key => value))
      end

      private

      def apply_plural(klass)
        accessor = self
        klass.send(:define_method, ::ActiveSupport::Inflector.pluralize(name)) do |*args|
          case args.count
          when 0 then next accessor.immutable_value_get(self)
          when 1 then next accessor.immutable_value_set(self, args[0])
          else
            raise ::ArgumentError, "wrong number of arguments (given #{args.count}, expected 0..1)"
          end
        end
      end

      def apply_singular(klass)
        accessor = self
        klass.send(:define_method, name) do |*args|
          case args.count
          when 1 then next accessor.immutable_value_get_single(self, args[0])
          when 2 then next accessor.immutable_value_set_single(self, *args[0..1])
          else
            raise ::ArgumentError, "wrong number of arguments (given #{args.count}, expected 1..2)"
          end
        end
      end
    end
  end
end
