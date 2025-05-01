# frozen_string_literal: true

require 'eac_ruby_utils/method_class'

class Module
  def enable_method_class
    ::EacRubyUtils.patch_module(self, ::EacRubyUtils::MethodClass)
  end
end
