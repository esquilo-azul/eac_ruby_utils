# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'
require 'eac_ruby_utils/recursive_builder'
require 'eac_ruby_utils/simple_cache'

module EacRubyUtils
  class GemsRegistry
    class Gem
      module PathsToRequire
        # @return [String]
        def path_to_require
          "#{gemspec.name.gsub('-', '/')}/#{registry.module_suffix.underscore}"
        end

        # @return [String]
        def to_s
          "#{self.class.name}[#{gemspec.name}]"
        end
      end
    end
  end
end
