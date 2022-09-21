# frozen_string_literal: true

require 'eac_ruby_utils/static_method_class'

class Module
  def enable_static_method_class
    ::EacRubyUtils.patch(self, ::EacRubyUtils::StaticMethodClass)
  end
end
