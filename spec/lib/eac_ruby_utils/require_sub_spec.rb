# frozen_string_literal: true

require 'eac_ruby_utils/require_sub'

RSpec.describe ::EacRubyUtils::RequireSub do
  class RequireSubStubClass
  end

  let(:instance) { described_class.new(__FILE__, base: RequireSubStubClass, include_modules: true) }

  before do
    instance.apply
  end

  it do
    expect(RequireSubStubClass.included_modules)
      .to include(RequireSubStubClass::StubbedModuleA)
  end
end
