# frozen_string_literal: true

require 'eac_ruby_utils/gems_registry'
require 'eac_ruby_utils/patches/object/if_respond'
require 'eac_ruby_utils/patches/object/to_pathname'

module EacRubyUtils
  module Rspec
    class SetupManager
      GEMS_REGISTRY_SUFFIX = 'Rspec::Setup'

      class << self
        def create(app_root_path, rspec_config = nil)
          if rspec_config
            new(app_root_path, rspec_config)
          else
            ::RSpec.configure { |new_rspec_config| new(app_root_path, new_rspec_config) }
          end
        end
      end

      attr_reader :app_root_path, :rspec_config

      def initialize(app_root_path, rspec_config)
        @app_root_path = app_root_path.to_pathname
        @rspec_config = rspec_config
        include_registry
      end

      # @return [EacRubyUtils::GemsRegistry]
      def gems_registry
        @gems_registry ||= ::EacRubyUtils::GemsRegistry.new(GEMS_REGISTRY_SUFFIX)
      end

      protected

      def include_registry
        gems_registry.registered.each do |gem|
          gem.registered_module.new(self).perform
        end
      end
    end
  end
end
