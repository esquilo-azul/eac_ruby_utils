# frozen_string_literal: true

require 'active_support/core_ext/module/introspection'
require 'eac_ruby_utils/patches/class/common_constructor'
require 'eac_ruby_utils/patches/module/listable'
require 'eac_ruby_utils/patches/module/module_parent'
require 'eac_ruby_utils/patches/string/inflector'

module EacRubyUtils
  class ActsAsInstanceMethod
    enable_listable
    lists.add_symbol :option

    common_constructor :method_class, :options, default: [{}] do
      self.options = ::EacRubyUtils::ActsAsInstanceMethod.lists.option.hash_keys_validate!(options)
    end

    # @param sender_module [Module, nil]
    # @return [self]
    def setup(sender_module = nil)
      sender_module ||= default_sender_module
      the_setup = self
      sender_module.define_method(method_name) do |*args, &block|
        the_setup.method_class.new(self, *args, &block).result
      end

      self
    end

    # @return [String]
    def method_name
      method_class.name.demodulize.underscore.variableize
    end

    # @return [Module]
    def default_sender_module
      method_class.module_parent
    end
  end
end
