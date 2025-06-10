# frozen_string_literal: true

class RequireSubStubClass # rubocop:disable Lint/EmptyClass
end

RSpec.describe EacRubyUtils::RequireSub::Base do
  let(:instance) { described_class.new(__FILE__, base: RequireSubStubClass, include_modules: true) }

  before do
    instance.apply
  end

  it do
    expect(RequireSubStubClass.included_modules)
      .to include(RequireSubStubClass::StubbedModuleA)
  end
end
