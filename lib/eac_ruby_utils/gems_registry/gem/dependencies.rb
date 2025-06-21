# frozen_string_literal: true

require 'eac_ruby_utils/recursive_builder'

module EacRubyUtils
  class GemsRegistry
    class Gem
      module Dependencies
        def depend_on(gem) # rubocop:disable Naming/PredicateMethod
          dependencies.lazy.map(&:name).include?(gem.gemspec.name)
        end

        def dependencies
          @dependencies ||= dependencies_uncached # dependencies_uncached
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
end
