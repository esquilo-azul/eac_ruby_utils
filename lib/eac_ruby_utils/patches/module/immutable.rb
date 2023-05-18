# frozen_string_literal: true

require 'eac_ruby_utils/patch'
require 'eac_ruby_utils/acts_as_immutable'

class Module
  def enable_immutable
    ::EacRubyUtils.patch(self, ::EacRubyUtils::ActsAsImmutable)
  end
end
