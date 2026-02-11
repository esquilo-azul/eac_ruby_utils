# frozen_string_literal: true

require 'eac_ruby_utils/listable'
require 'eac_ruby_utils/require_sub/sub_file'

module EacRubyUtils
  module RequireSub
    class Base
      INCLUDE_MODULES_MAP = {
        nil => nil,
        false => nil,
        true => :include,
        extend: :extend,
        include: :include,
        prepend: :prepend
      }.freeze

      include ::EacRubyUtils::Listable

      lists.add_symbol :option, :base, :include_modules, :recursive, :require_dependency,
                       :require_mode
      lists.add_symbol :require_mode, :active_support, :autoload, :kernel

      attr_reader :file, :options

      def initialize(file, options = {})
        @file = file
        @options = self.class.lists.option.hash_keys_validate!(options)
        return unless options[OPTION_REQUIRE_MODE]

        self.class.lists.require_mode.value_validate!(options[OPTION_REQUIRE_MODE])
      end

      # @return [Boolean]
      def active_support_require?
        options[OPTION_REQUIRE_DEPENDENCY] ? true : false
      end

      def apply
        raise('Options :base and :recursive cannot be simultaneously present/true') if
          base? && recursive?

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

        raise ::ArgumentError, "Invalid value for 'options[OPTION_INCLUDE_MODULES]': " \
                               "\"#{options[OPTION_INCLUDE_MODULES]}\""
      end

      # @return [Boolean]
      def recursive?
        options.fetch(OPTION_RECURSIVE, false) ? true : false
      end

      # @return [Symbol]
      def require_mode
        return options[OPTION_REQUIRE_MODE] if options[OPTION_REQUIRE_MODE]
        return REQUIRE_MODE_ACTIVE_SUPPORT if active_support_require?
        return REQUIRE_MODE_AUTOLOAD if base?

        REQUIRE_MODE_KERNEL
      end

      def require_sub_files
        sub_files.each(&:require_file)
      end

      # @return [Enumerable<EacRubyUtils::RequireSub::SubFile>]
      def sub_files
        @sub_files ||= Dir["#{File.dirname(file)}/#{::File.basename(file, '.*')}" \
                           "#{'/**' if recursive?}/*.rb"].sort
                       .map { |path| ::EacRubyUtils::RequireSub::SubFile.new(self, path) }
      end
    end
  end
end
