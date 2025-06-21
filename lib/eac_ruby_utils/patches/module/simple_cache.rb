# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/patch_self'
require 'eac_ruby_utils/simple_cache'

class Module
  def enable_simple_cache
    patch_self(::EacRubyUtils::SimpleCache)
  end
end
