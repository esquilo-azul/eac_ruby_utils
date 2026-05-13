# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/ruby/on_replace_objects/replace_instance_method'

module EacRubyUtils
  module Ruby
    class << self
      def on_replace_objects
        replacer = OnReplaceObjects.new
        replacer.on_replacement do
          yield(replacer)
        end
      end
    end

    class OnReplaceObjects
      def on_replacement(&block)
        clear_replacements
        block.call(self)
      ensure
        restore_replacements
      end

      def replace_instance_method(a_module, method_name, &)
        add_replacement(__method__, a_module, method_name, &)
      end

      def replace_self_method(object, method_name, &)
        add_replacement(:replace_instance_method, object.singleton_class, method_name, &)
      end

      private

      def add_replacement(method_name, *, &)
        @replacements << replacement_class(method_name).new(*, &).apply
      end

      def replacement_class(method_name)
        self.class.const_get(::ActiveSupport::Inflector.camelize(method_name))
      end

      def clear_replacements
        @replacements = []
      end

      def restore_replacements
        @replacements.reverse.each(&:restore)
      end
    end
  end
end
