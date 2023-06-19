# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_instance_method'

class Module
  # @return [EacRubyUtils::ActsAsInstanceMethod]
  def acts_as_instance_method
    ::EacRubyUtils::ActsAsInstanceMethod.new(self).setup
  end
end
