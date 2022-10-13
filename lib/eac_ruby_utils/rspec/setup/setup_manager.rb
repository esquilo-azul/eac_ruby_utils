# frozen_string_literal: true

module EacRubyUtils
  module Rspec
    module Setup
      module SetupManager
        # @return [Pathname]
        delegate :app_root_path, to: :setup_manager

        # @return [EacRubyUtils::Rspec::SetupManager]
        def setup_manager
          ::RSpec.configuration.setup_manager
        end
      end
    end
  end
end
