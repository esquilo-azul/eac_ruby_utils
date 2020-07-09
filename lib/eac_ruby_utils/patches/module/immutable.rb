# frozen_string_literal: true

require 'eac_ruby_utils/patch'
require 'eac_ruby_utils/immutable'

class Module
  def enable_immutable
    ::EacRubyUtils.patch(self, ::EacRubyUtils::Immutable)
  end
end
