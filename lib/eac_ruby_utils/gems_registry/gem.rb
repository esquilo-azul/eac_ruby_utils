# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/recursive_builder'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class GemsRegistry
    class Gem
      include ::Comparable
      include ::EacRubyUtils::SimpleCache

      attr_reader :registry, :gemspec

      def initialize(registry, gemspec)
        @registry = registry
        @gemspec = gemspec
      end

      def depend_on(gem)
        dependencies.lazy.map(&:name).include?(gem.gemspec.name)
      end

      def dependencies
        @dependencies ||= dependencies_uncached # dependencies_uncached
      end

      def <=>(other)
        sd = depend_on(other)
        od = other.depend_on(self)
        return 1 if sd && !od
        return -1 if od && !sd

        gemspec.name <=> other.gemspec.name
      end

      def found?
        lib_file_found? && registered_module.is_a?(::Module)
      end

      def lib_file_found?
        gemspec.require_paths.any? do |require_path|
          ::Pathname.new(require_path).expand_path(gemspec.gem_dir).join("#{path_to_require}.rb")
            .file?
        end
      end

      def registered_module
        return nil unless lib_file_found?

        require path_to_require
        path_to_require.camelize.constantize
      end

      # @return [String]
      def path_to_require
        "#{gemspec.name.gsub('-', '/')}/#{registry.module_suffix.underscore}"
      end

      def to_s
        "#{self.class.name}[#{gemspec.name}]"
      end

      private

      def dependencies_uncached
        ::EacRubyUtils::RecursiveBuilder
          .new(gemspec) { |item| gem_item_dependencies(item) }
          .result
      end

      # @return [Array<Gem::Dependency>]
      def gem_item_dependencies(item)
        ::Gem::Specification.find_by_name(item.name).dependencies.select(&:runtime?)
      rescue ::Gem::MissingSpecError
        []
      end
    end
  end
end
