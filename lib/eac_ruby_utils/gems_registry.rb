# frozen_string_literal: true

require 'rubygems'
require 'eac_ruby_utils/gems_registry/gem'

module EacRubyUtils
  # Search in each gem for a class determined by registry and run the method "register" on each
  # found.
  #
  # Example:
  # * The module suffix is `TheClass`;
  # * A gem with name "my-lib" is being analyzed
  # * If a require for "my/lib/the_class" is succesful the class/module `My::Lib::TheClass` will
  #   be collected.
  class GemsRegistry
    attr_reader :module_suffix

    def initialize(module_suffix)
      @module_suffix = module_suffix
    end

    # @return [Array<EacRubyUtils::GemsRegistry::Gem>]
    def registered
      @registered ||= all_gems.select(&:found?).sort
    end

    private

    # @return [Array<EacRubyUtils::GemsRegistry::Gem>]
    def all_gems
      ::Gem::Specification.map { |gemspec| ::EacRubyUtils::GemsRegistry::Gem.new(self, gemspec) }
    end
  end
end
