# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/console_speaker'

RSpec.describe ::Module do
  class StubClass
    enable_console_speaker
  end

  describe '#enable_console_speaker' do
    it { expect(StubClass.included_modules).to include(::EacRubyUtils::Console::Speaker) }
  end
end
