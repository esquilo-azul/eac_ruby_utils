# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module EacRubyUtils
  module Rspec
    module Setup
      require_sub __FILE__

      def self.extended(obj)
        obj.extend(::EacRubyUtils::Rspec::Setup::Conditionals)
        obj.rspec_config.add_setting :setup_manager
        obj.rspec_config.setup_manager = obj
        obj.rspec_config.include(::EacRubyUtils::Rspec::Setup::SetupManager)
      end
    end
  end
end
