# frozen_string_literal: true

require 'eac_ruby_utils/patch_module'
require 'eac_ruby_utils/settings_provider'

class Class
  def enable_settings_provider
    ::EacRubyUtils.patch_module(self, ::EacRubyUtils::SettingsProvider)
  end
end
