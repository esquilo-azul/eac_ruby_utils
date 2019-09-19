# frozen_string_literal: true

require 'eac_ruby_utils/patch'

class Module
  def patch(patch_module)
    ::Eac::Ruby::Utils.patch(self, patch_module)
  end
end
