# frozen_string_literal: true

require 'eac_ruby_utils/recursive_builder'
require 'memoized'

module EacRubyUtils
  class GemsRegistry
    class Gem
      module Dependencies
        include ::Memoized

        def depend_on(gem) # rubocop:disable Naming/PredicateMethod
          dependencies.lazy.map(&:name).include?(gem.gemspec.name)
        end

        memoize def dependencies
          ::EacRubyUtils::RecursiveBuilder
            .new(gemspec) { |item| gem_item_dependencies(item) }
            .result
        end

        private

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
