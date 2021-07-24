# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

module EacRubyUtils
  class GemsRegistry
    class Gem
      attr_reader :registry, :gemspec

      def initialize(registry, gemspec)
        @registry = registry
        @gemspec = gemspec
      end

      def found?
        lib_file_found? && registered_module.is_a?(::Module)
      end

      def lib_file_found?
        gemspec.require_paths.any? do |require_path|
          ::Pathname.new(require_path).expand_path(gemspec.gem_dir).join(path_to_require + '.rb')
                    .file?
        end
      end

      def registered_module
        return nil unless lib_file_found?

        require path_to_require
        path_to_require.classify.constantize
      end

      # @return [String]
      def path_to_require
        gemspec.name.gsub('-', '/') + '/' + registry.module_suffix.underscore
      end
    end
  end
end
