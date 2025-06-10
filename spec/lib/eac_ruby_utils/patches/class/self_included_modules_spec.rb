# frozen_string_literal: true

RSpec.describe Class, '#self_included_modules' do
  let(:includeable_module) do
    Module.new
  end

  let(:parent_class) do
    module_to_include = includeable_module
    described_class.new do
      include module_to_include
    end
  end

  let(:child_class) do
    described_class.new(parent_class)
  end

  describe '#self_included_modules' do
    it do
      expect(parent_class.self_included_modules).to include(includeable_module)
    end

    it do
      expect(child_class.self_included_modules).not_to include(includeable_module)
    end
  end
end
