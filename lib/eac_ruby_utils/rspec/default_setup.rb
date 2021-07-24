# frozen_string_literal: true

require 'eac_ruby_utils/rspec/setup'

module EacRubyUtils
  module Rspec
    class << self
      def default_setup
        @default_setup ||
          raise("Default instance was not set. Use #{self.class.name}.default_setup_create")
      end

      def default_setup_create(app_root_path, rspec_config = nil)
        @default_setup = ::EacRubyUtils::Rspec::Setup.create(app_root_path, rspec_config)
      end
    end
  end
end
