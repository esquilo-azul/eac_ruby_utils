# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/recursive_builder'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class GemsRegistry
    class Gem
      module PathsToRequire
        ROOT_MODULE_REQUIRE_PATTERNS = %w[EacRubyUtils::RootModuleSetup Zeitwerk].freeze

        # @return [Enumerable<Pathname>]
        def absolute_require_paths(lib_relative_path)
          gemspec.require_paths.lazy.map do |e|
            ::Pathname.new(e).expand_path(gemspec.gem_dir)
              .join("#{lib_relative_path}.rb")
          end
        end

        # @return [String]
        def path_to_require
          require_root_module? ? root_module_path_to_require : direct_path_to_require
        end

        # @return [String]
        def to_s
          "#{self.class.name}[#{gemspec.name}]"
        end

        protected

        # @return [String]
        def direct_path_to_require
          "#{root_module_path_to_require}/#{registry.module_suffix.underscore}"
        end

        # @return [Boolean]
        def require_root_module?
          absolute_require_paths(root_module_path_to_require).find do |e|
            next false unless e.file?

            content = e.read
            ROOT_MODULE_REQUIRE_PATTERNS.any? { |e| content.include?(e) }
          end
        end

        # @return [String]
        def root_module_path_to_require
          gemspec.name.gsub('-', '/')
        end
      end
    end
  end
end
