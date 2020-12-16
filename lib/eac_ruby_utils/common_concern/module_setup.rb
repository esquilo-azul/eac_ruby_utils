# frozen_string_literal: true

require 'active_support/concern'
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
        setup = self
        a_module.extend(::ActiveSupport::Concern)
        a_module.included do
          %w[class_methods instance_methods after_callback].each do |suffix|
            setup.send("setup_#{suffix}", self)
          end
        end
      end

      def setup_class_methods(base)
        class_methods_module.if_present { |v| base.extend v }
      end

      def setup_instance_methods(base)
        instance_methods_module.if_present { |v| base.include v }
      end

      def setup_after_callback(base)
        common_concern.after_callback.if_present do |v|
          base.instance_eval(&v)
        end
      end

      def class_methods_module_uncached
        a_module.const_get(CLASS_METHODS_MODULE_NAME)
      rescue NameError
        nil
      end

      def instance_methods_module_uncached
        a_module.const_get(INSTANCE_METHODS_MODULE_NAME)
      rescue NameError
        nil
      end
    end
  end
end
