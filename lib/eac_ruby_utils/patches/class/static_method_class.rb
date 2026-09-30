# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_static_method'

class Class
  # @return [EacRubyUtils::ActsAsStaticMethod]
  def enable_static_method_class
    ::EacRubyUtils::ActsAsStaticMethod.new(self).setup
  end
end
