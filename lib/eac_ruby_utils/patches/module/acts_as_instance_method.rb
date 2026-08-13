# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_instance_method'

class Module
  # @param options [Hash]
  # @return [EacRubyUtils::ActsAsInstanceMethod]
  def acts_as_instance_method(**options)
    ::EacRubyUtils::ActsAsInstanceMethod.new(self, options).setup
  end
end
