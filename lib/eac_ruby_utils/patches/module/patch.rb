# frozen_string_literal: true

require 'eac_ruby_utils/patch_module'

class Module
  def patch(patch_module)
    ::EacRubyUtils.patch(self, patch_module)
  end
end
