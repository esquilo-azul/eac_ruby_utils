# frozen_string_literal: true

require 'eac_ruby_utils/patch'
require 'eac_ruby_utils/contextualizable'

class Module
  # Patches module with [EacRubyUtils::Contextualizable].
  def enable_context
    ::EacRubyUtils.patch(self, ::EacRubyUtils::Contextualizable)
  end
end
