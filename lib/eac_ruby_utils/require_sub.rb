# frozen_string_literal: true

require 'active_support/inflector'
require 'active_support/dependencies'
require 'eac_ruby_utils/listable'

module EacRubyUtils
  class << self
    def require_sub(file, options = {})
      ::EacRubyUtils::RequireSub.new(file, options).apply
    end
  end

  class RequireSub
    INCLUDE_MODULES_MAP = {
      nil => nil,
      false => nil,
      true => :include,
      include: :include,
      prepend: :prepend
    }.freeze

    include ::EacRubyUtils::Listable
    lists.add_symbol :option, :base, :include_modules, :require_dependency

    attr_reader :file, :options

    def initialize(file, options = {})
      @file = file
      @options = self.class.lists.option.hash_keys_validate!(options)
    end

    def apply
      require_sub_files
      include_modules
    end

    def base
      options[OPTION_BASE] || raise('Option :base not setted')
    end

    def base?
      options[OPTION_BASE] ? true : false
    end

    def include_modules
      sub_files.each(&:include_module)
    end

    def include_or_prepend_method
      return INCLUDE_MODULES_MAP.fetch(options[OPTION_INCLUDE_MODULES]) if
        INCLUDE_MODULES_MAP.key?(options[OPTION_INCLUDE_MODULES])

      raise ::ArgumentError, "Invalid value for 'options[OPTION_INCLUDE_MODULES]':" \
         " \"#{options[OPTION_INCLUDE_MODULES]}\""
    end

    def require_sub_files
      sub_files.each(&:require_file)
    end

    def sub_files
      @sub_files ||= Dir["#{File.dirname(file)}/#{::File.basename(file, '.*')}/*.rb"].sort
                       .map { |path| SubFile.new(self, path) }
    end

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

      def include_or_prepend_method
        return :include if owner.options[OPTION_INCLUDE_MODULES]
        return :prepend if owner.options[OPTION_PREPEND_MODULES]

        nil
      end

      def module?
        base_constant.is_a?(::Module) && !base_constant.is_a?(::Class)
      end

      def require_file
        active_support_require || autoload_require || kernel_require
      end

      private

      def active_support_require
        return false unless owner.options[OPTION_REQUIRE_DEPENDENCY]

        ::Kernel.require_dependency(path)
        true
      end

      def autoload_require
        return false unless owner.base?

        basename = ::File.basename(path, '.*')
        return false if basename.start_with?('_')

        owner.base.autoload ::ActiveSupport::Inflector.camelize(basename), path
        true
      end

      def kernel_require
        ::Kernel.require(path)
      end
    end
  end
end
