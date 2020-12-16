# frozen_string_literal: true

require 'active_support/concern'
require 'eac_ruby_utils/simple_cache'
require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  class CommonConcern
    class ClassSetup
      include ::EacRubyUtils::SimpleCache
      attr_reader :a_class, :module_setup, :include_method

      def initialize(module_setup, a_class, include_method)
        @module_setup = module_setup
        @a_class = a_class
        @include_method = include_method
      end

      def run
        %w[class_methods instance_methods after_callback].each do |suffix|
          send("setup_#{suffix}")
        end
      end

      def setup_class_methods
        class_methods_module.if_present { |v| a_class.extend v }
      end

      def setup_instance_methods
        instance_methods_module.if_present { |v| a_class.send(include_method, v) }
      end

      def setup_after_callback
        module_setup.common_concern.after_callback.if_present do |v|
          a_class.instance_eval(&v)
        end
      end

      def class_methods_module_uncached
        module_setup.a_module.const_get(CLASS_METHODS_MODULE_NAME)
      rescue NameError
        nil
      end

      def instance_methods_module_uncached
        module_setup.a_module.const_get(INSTANCE_METHODS_MODULE_NAME)
      rescue NameError
        nil
      end
    end
  end
end
