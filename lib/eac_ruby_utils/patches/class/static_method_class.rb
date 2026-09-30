# frozen_string_literal: true

require 'eac_ruby_utils/static_method_class'

class Class
  def enable_static_method_class
    ::EacRubyUtils.patch_module(self, ::EacRubyUtils::StaticMethodClass)
  end
end
