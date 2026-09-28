# frozen_string_literal: true

require 'eac_ruby_utils/patches/class/acts_as_static_method'

class Class
  # @return [EacRubyUtils::ActsAsStaticMethod]
  # @deprecated Use {#acts_as_static_method} instead.
  def enable_static_method_class
    ::EacRubyUtils::ActsAsStaticMethod.new(self).setup
    acts_as_static_method
  end
end
