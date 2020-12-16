# frozen_string_literal: true

require 'active_support/concern'
require 'eac_ruby_utils/common_concern/class_setup'
require 'eac_ruby_utils/simple_cache'
require 'eac_ruby_utils/patches/object/if_present'

module EacRubyUtils
  class CommonConcern
    class ModuleSetup
      include ::EacRubyUtils::SimpleCache
      attr_reader :a_module, :common_concern

      def initialize(common_concern, a_module)
        @common_concern = common_concern
        @a_module = a_module
      end

      def run
        setup = self
        a_module.extend(::ActiveSupport::Concern)
        a_module.included do
          ::EacRubyUtils::CommonConcern::ClassSetup.new(setup, self, :include).run
        end
        a_module.prepended do
          ::EacRubyUtils::CommonConcern::ClassSetup.new(setup, self, :prepend).run
        end
      end
    end
  end
end
