# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor/instance_initialize'
require 'eac_ruby_utils/common_constructor/super_args'

module EacRubyUtils
  class CommonConstructor
    class ClassInitialize
      attr_reader :common_constructor, :klass

      def initialize(common_constructor, klass)
        @common_constructor = common_constructor
        @klass = klass
      end

      def define_initialize_callbacks
        klass.include(::ActiveSupport::Callbacks)
        klass.define_callbacks :initialize
      end

      def define_initialize_method
        class_initialize = self
        klass.send(:define_method, :initialize) do |*args|
          ::EacRubyUtils::CommonConstructor::InstanceInitialize.new(
            class_initialize.common_constructor, args, self
          ).run
          super(*::EacRubyUtils::CommonConstructor::SuperArgs.new(
            class_initialize, args, self
          ).result)
        end
      end

      def perform
        define_initialize_callbacks
        define_initialize_method
      end
    end
  end
end
