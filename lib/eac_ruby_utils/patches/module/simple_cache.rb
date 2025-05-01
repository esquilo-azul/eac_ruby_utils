# frozen_string_literal: true

require 'eac_ruby_utils/patch_module'
require 'eac_ruby_utils/simple_cache'

class Module
  def enable_simple_cache
    ::EacRubyUtils.patch(self, ::EacRubyUtils::SimpleCache)
  end
end
