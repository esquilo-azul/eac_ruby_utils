# frozen_string_literal: true

require 'eac_ruby_utils/patch'
require 'eac_ruby_utils/settings_provider'

class Class
  def enable_settings_provider
    ::EacRubyUtils.patch(self, ::EacRubyUtils::SettingsProvider)
  end
end
