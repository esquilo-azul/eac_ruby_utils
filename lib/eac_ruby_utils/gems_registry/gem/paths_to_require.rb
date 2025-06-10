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
          direct_path_to_require
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

        # @return [String]
        def root_module_path_to_require
          gemspec.name.gsub('-', '/')
        end
      end
    end
  end
end
