# frozen_string_literal: true

require 'eac_ruby_utils/common_concern/module_setup'

module EacRubyUtils
  class CommonConcern
    CLASS_METHODS_MODULE_NAME = 'ClassMethods'
    INSTANCE_METHODS_MODULE_NAME = 'InstanceMethods'

    attr_reader :after_callback

    def initialize(&after_callback)
      @after_callback = after_callback
    end

    def setup(a_module)
      ::EacRubyUtils::CommonConcern::ModuleSetup.new(self, a_module).run
    end
  end
end
