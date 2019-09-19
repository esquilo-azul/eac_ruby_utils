# frozen_string_literal: true

require 'eac_ruby_utils/patch'
require 'eac_ruby_utils/console/speaker'

class Module
  def enable_console_speaker
    ::EacRubyUtils.patch(self, ::EacRubyUtils::Console::Speaker)
  end
end
