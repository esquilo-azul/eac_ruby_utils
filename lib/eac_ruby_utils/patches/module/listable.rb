# frozen_string_literal: true

require 'eac_ruby_utils/patch_module'
require 'eac_ruby_utils/listable'

class Module
  def enable_listable
    ::EacRubyUtils.patch(self, ::EacRubyUtils::Listable)
  end
end
