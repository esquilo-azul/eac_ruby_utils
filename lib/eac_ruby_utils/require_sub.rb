# frozen_string_literal: true

require 'active_support/inflector'
require 'eac_ruby_utils/listable'

module EacRubyUtils
  class << self
    def require_sub(file, options = {})
      ::EacRubyUtils::RequireSub.new(file, options).apply
    end
  end

  class RequireSub
    include ::EacRubyUtils::Listable
    lists.add_symbol :option, :base, :include_modules, :require_dependency

    attr_reader :file, :options

    def initialize(file, options = {})
      @file = file
      @options = options
    end

    def apply
      require_sub_files
      include_modules
    end

    private

    def active_support_require(path)
      return false unless options[OPTION_REQUIRE_DEPENDENCY]

      ::Kernel.require_dependency(path)
      true
    end

    def autoload_require(path)
      return false unless base?

      basename = ::File.basename(path, '.*')
      return false if basename.start_with?('_')

      base.autoload ::ActiveSupport::Inflector.camelize(basename), path
      true
    end

    def include_modules
      return unless options[OPTION_INCLUDE_MODULES]

      base.constants.each do |constant_name|
        constant = base.const_get(constant_name)
        next unless constant.is_a?(::Module) && !constant.is_a?(::Class)

        base.include(constant)
      end
    end

    def base
      options[OPTION_BASE] || raise('Option :base not setted')
    end

    def base?
      options[OPTION_BASE] ? true : false
    end

    def kernel_require(path)
      ::Kernel.require(path)
    end

    def require_sub_files
      Dir["#{File.dirname(file)}/#{::File.basename(file, '.*')}/*.rb"].sort.each do |path|
        require_sub_file(path)
      end
    end

    def require_sub_file(path)
      active_support_require(path) || autoload_require(path) || kernel_require(path)
    end
  end
end
