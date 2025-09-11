# frozen_string_literal: true

require 'active_support/concern'
require 'eac_ruby_utils/common_concern/class_setup'
require 'eac_ruby_utils/simple_cache'
require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  class CommonConcern
    class ModuleSetup
      include ::EacRubyUtils::SimpleCache

      attr_reader :a_module, :common_concern

      def initialize(common_concern, a_module)
        @common_concern = common_concern
        @a_module = a_module
      end

      def run
        a_module.extend(::ActiveSupport::Concern)
        include_or_prepend(:included, :include)
        include_or_prepend(:prepended, :prepend)
      end

      private

      def include_or_prepend(module_method, class_setup_method)
        setup = self
        a_module.send(module_method, *a_module_method_args(module_method)) do
          ::EacRubyUtils::CommonConcern::ClassSetup.new(setup, self, class_setup_method).run
        end
      end

      def a_module_method_args(module_method)
        method_arity = a_module.method(module_method).arity
        method_arity = -method_arity - 1 if method_arity.negative?
        method_arity.times.map { |_n| a_module }
      end
    end
  end
end
