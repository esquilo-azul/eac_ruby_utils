# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_instance_method'

module EacRubyUtils
  class ActsAsStaticMethod < ::EacRubyUtils::ActsAsInstanceMethod
    # @return [Module]
    def default_sender_module
      method_class.module_parent.singleton_class
    end
  end
end
