# frozen_string_literal: true

require 'eac_ruby_utils/rspec/setup_manager'

module EacRubyUtils
  module Rspec
    module DefaultSetup
      common_concern
      class_methods do
        # @return [EacRubyUtils::Rspec::SetupManager]
        def default_setup
          @default_setup ||
            raise("Default instance was not set. Use #{self.class.name}.default_setup_create")
        end

        # @return [EacRubyUtils::Rspec::SetupManager]
        def default_setup_create(app_root_path, rspec_config = nil)
          @default_setup = ::EacRubyUtils::Rspec::SetupManager.create(app_root_path, rspec_config)
        end
      end
    end
  end
end
