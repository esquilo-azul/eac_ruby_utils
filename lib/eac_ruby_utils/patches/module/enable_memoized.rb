# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/patch_self'
require 'memoized'

class Module
  def enable_memoized
    patch_self(::Memoized)
  end
end
