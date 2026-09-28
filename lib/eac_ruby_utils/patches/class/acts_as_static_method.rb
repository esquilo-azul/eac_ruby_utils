# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_static_method'

class Class
  # @param options [Hash]
  # @return [EacRubyUtils::ActsAsStaticMethod]
  def acts_as_static_method(**options)
    ::EacRubyUtils::ActsAsStaticMethod.new(self, options).setup
  end
end
