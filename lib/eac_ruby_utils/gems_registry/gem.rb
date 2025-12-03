# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/gems_registry/gem/dependencies'
require 'eac_ruby_utils/gems_registry/gem/paths_to_require'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class GemsRegistry
    class Gem
      include ::Comparable
      include ::EacRubyUtils::GemsRegistry::Gem::Dependencies
      include ::EacRubyUtils::GemsRegistry::Gem::PathsToRequire
      include ::EacRubyUtils::SimpleCache

      attr_reader :registry, :gemspec

      def initialize(registry, gemspec)
        @registry = registry
        @gemspec = gemspec
      end

      def <=>(other)
        sd = depend_on(other)
        od = other.depend_on(self)
        return 1 if sd && !od
        return -1 if od && !sd

        gemspec.name <=> other.gemspec.name
      end

      def found?
        registered_module.is_a?(::Module)
      end

      # @return [Module, nil]
      def registered_module
        require path_to_require
        direct_path_to_require.camelize.constantize
      rescue ::LoadError, ::NameError
        nil
      end
    end
  end
end
