# frozen_string_literal: true

RSpec.describe(EacRubyUtils::ModuleAncestorsVariable::Hash) do
  let(:included_module) do
    Module.new do
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods # rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
        def hash_variable
          @hash_variable ||= ::EacRubyUtils::ModuleAncestorsVariable::Hash.new(self, __method__)
        end
      end
    end
  end

  let(:super_class) do
    r = Class.new
    r.include included_module
    r
  end

  let(:sub_class) do
    Class.new(super_class)
  end

  it { expect(super_class.hash_variable).to be_a(described_class) }
  it { expect(super_class.hash_variable.self_variable).to eq({}) }
  it { expect(super_class.hash_variable.ancestors_variable).to eq({}) }
  it { expect(super_class.hash_variable.to_h).to eq({}) }

  it { expect(sub_class.hash_variable).to be_a(described_class) }
  it { expect(sub_class.hash_variable.self_variable).to eq({}) }
  it { expect(sub_class.hash_variable.ancestors_variable).to eq({}) }
  it { expect(sub_class.hash_variable.to_h).to eq({}) }

  context 'when super class is changed' do
    before do
      super_class.hash_variable[:by_super] = 1
    end

    it { expect(super_class.hash_variable.to_h).to eq({ by_super: 1 }) }
    it { expect(sub_class.hash_variable.to_h).to eq({ by_super: 1 }) }

    context 'when sub class is changed' do
      before do
        sub_class.hash_variable[:by_sub] = 2
      end

      it { expect(super_class.hash_variable.to_h).to eq({ by_super: 1 }) }
      it { expect(sub_class.hash_variable.to_h).to eq({ by_super: 1, by_sub: 2 }) }
    end
  end
end
