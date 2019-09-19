# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/simple_cache'

RSpec.describe ::Module do
  class StubClass
    enable_simple_cache
  end

  describe '#enable_simple_cache' do
    it { expect(StubClass.included_modules).to include(::EacRubyUtils::SimpleCache) }
  end
end
