# frozen_string_literal: true

require 'active_support/core_ext/module/introspection'
require 'eac_ruby_utils/patches/class/common_constructor'
require 'eac_ruby_utils/patches/module/common_concern'
require 'eac_ruby_utils/patches/module/module_parent'
require 'eac_ruby_utils/patches/string/inflector'

module EacRubyUtils
  module MethodClass
    common_concern do
      ::EacRubyUtils::MethodClass::Setup.new(self)
    end

    class Setup
      common_constructor :method_class do
        perform
      end

      def perform
        the_setup = self
        sender_module.define_method(method_name) do |*args, &block|
          the_setup.method_class.new(self, *args, &block).result
        end
      end

      def method_name
        method_class.name.demodulize.underscore.variableize
      end

      def sender_module
        method_class.module_parent
      end
    end
  end
end
