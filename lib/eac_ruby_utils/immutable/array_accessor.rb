# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/immutable/base_accessor'
require 'eac_ruby_utils/patches/class/common_constructor'

module EacRubyUtils
  module Immutable
    class ArrayAccessor < ::EacRubyUtils::Immutable::BaseAccessor
      def apply(klass)
        accessor = self
        klass.send(:define_method, name) do |value|
          accessor.immutable_value_set(self, value)
        end

        klass.send(:define_method, ::ActiveSupport::Inflector.pluralize(name)) do
          accessor.immutable_value_get(self)
        end
      end

      def immutable_value_set(object, value)
        duplicate_object(object) do |old_value|
          (old_value || []) + [value]
        end
      end
    end
  end
end
