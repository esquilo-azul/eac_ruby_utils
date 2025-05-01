# frozen_string_literal: true

require 'eac_ruby_utils/patch_module'

class Module
  def patch_self(patch_module)
    ::EacRubyUtils.patch_module(self, patch_module)
  end
end
