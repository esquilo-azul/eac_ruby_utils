# frozen_string_literal: true

require 'eac_ruby_utils/patch_module'
require 'eac_ruby_utils/contextualizable'

class Module
  # Patches module with [EacRubyUtils::Contextualizable].
  def enable_context
    ::EacRubyUtils.patch_module(self, ::EacRubyUtils::Contextualizable)
  end
end
