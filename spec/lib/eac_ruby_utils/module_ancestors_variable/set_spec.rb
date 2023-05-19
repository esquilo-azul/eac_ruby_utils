# frozen_string_literal: true

require 'eac_ruby_utils/module_ancestors_variable/set'

::RSpec.describe(::EacRubyUtils::ModuleAncestorsVariable::Set) do
  let(:included_module) do
    ::Module.new do
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods # rubocop:disable RSpec/LeakyConstantDeclaration
        def set_variable
          @set_variable ||= ::EacRubyUtils::ModuleAncestorsVariable::Set.new(self, __method__)
        end
      end
    end
  end

  let(:super_class) do
    r = ::Class.new
    r.include included_module
    r
  end

  let(:sub_class) do
    ::Class.new(super_class)
  end

  it { expect(super_class.set_variable).to be_a(described_class) }
  it { expect(super_class.set_variable.self_variable).to eq(::Set.new) }
  it { expect(super_class.set_variable.ancestors_variable).to eq(::Set.new) }
  it { expect(super_class.set_variable.to_set).to eq(::Set.new) }

  it { expect(sub_class.set_variable).to be_a(described_class) }
  it { expect(sub_class.set_variable.self_variable).to eq(::Set.new) }
  it { expect(sub_class.set_variable.ancestors_variable).to eq(::Set.new) }
  it { expect(sub_class.set_variable.to_set).to eq(::Set.new) }

  context 'when super class is changed' do
    before do
      super_class.set_variable << 1
    end

    it { expect(super_class.set_variable.to_set).to eq(::Set.new([1])) }
    it { expect(sub_class.set_variable.to_set).to eq(::Set.new([1])) }

    context 'when sub class is changed' do
      before do
        sub_class.set_variable << 2
      end

      it { expect(super_class.set_variable.to_set).to eq(::Set.new([1])) }
      it { expect(sub_class.set_variable.to_set).to eq(::Set.new([1, 2])) }
    end
  end
end
