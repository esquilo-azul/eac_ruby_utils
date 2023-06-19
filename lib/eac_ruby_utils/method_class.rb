# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_instance_method'
require 'eac_ruby_utils/patches/class/common_constructor'
require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  module MethodClass
    common_concern do
      ::EacRubyUtils::MethodClass::Setup.new(self)
    end

    class Setup < ::EacRubyUtils::ActsAsInstanceMethod
      common_constructor :method_class, :static_method, default: [false],
                                                        super_args: -> { [method_class] } do
        perform
      end

      def perform
        setup
      end

      def default_sender_module
        r = super
        r = r.singleton_class if static_method
        r
      end
    end
  end
end
