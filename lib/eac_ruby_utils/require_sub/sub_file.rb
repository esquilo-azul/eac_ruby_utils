# frozen_string_literal: true

require 'active_support/dependencies'
require 'active_support/inflector'

module EacRubyUtils
  module RequireSub
    class SubFile
      attr_reader :owner, :path

      def initialize(owner, path)
        @owner = owner
        @path = path
      end

      def base_constant
        return nil unless owner.base?

        owner.base.const_get(constant_name)
      rescue ::NameError
        nil
      end

      def constant_name
        ::ActiveSupport::Inflector.camelize(::File.basename(path, '.rb'))
      end

      def include_module
        return unless module?

        owner.include_or_prepend_method.if_present do |v|
          owner.base.send(v, base_constant)
        end
      end

      def module?
        base_constant.is_a?(::Module) && !base_constant.is_a?(::Class)
      end

      def require_file
        active_support_require || autoload_require || kernel_require
      end

      private

      def active_support_require
        return false unless owner.active_support_require?

        ::Kernel.require_dependency(path)
        true
      end

      def autoload_require
        return false unless owner.base?

        owner.base.autoload ::ActiveSupport::Inflector.camelize(::File.basename(path, '.*')), path
        true
      end

      def kernel_require
        ::Kernel.require(path)
      end
    end
  end
end
