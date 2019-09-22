# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/listable'

RSpec.describe ::Module do
  class StubClass
    enable_listable
  end

  describe '#enable_listable' do
    it { expect(StubClass.included_modules).to include(::EacRubyUtils::Listable) }
  end
end
