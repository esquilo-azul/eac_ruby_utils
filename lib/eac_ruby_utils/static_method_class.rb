# frozen_string_literal: true

require 'eac_ruby_utils/method_class'
require 'eac_ruby_utils/patches/module/common_concern'

module EacRubyUtils
  module StaticMethodClass
    common_concern do
      ::EacRubyUtils::MethodClass::Setup.new(self, true)
    end
  end
end
