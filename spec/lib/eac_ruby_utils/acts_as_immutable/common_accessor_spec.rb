# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_immutable'

::RSpec.describe ::EacRubyUtils::ActsAsImmutable::CommonAccessor do
  let(:stub_class) do
    ::Class.new do
      include ::EacRubyUtils::ActsAsImmutable

      immutable_accessor :attr1, :attr2, :attr3
    end
  end

  let(:initial_instance) { stub_class.new }

  it { expect(initial_instance.attr1).to eq(nil) }
  it { expect(initial_instance.attr2).to eq(nil) }
  it { expect(initial_instance.attr3).to eq(nil) }

  context 'when attr1 is set' do
    let(:change1_instance) { initial_instance.attr1('A') }

    it { expect(change1_instance).to be_a(initial_instance.class) }
    it { expect(change1_instance.object_id).not_to eq(initial_instance.object_id) }
    it { expect(change1_instance.attr1).to eq('A') }
    it { expect(change1_instance.attr2).to eq(nil) }
    it { expect(change1_instance.attr3).to eq(nil) }

    context 'when attr2 is set' do
      let(:change2_instance) { change1_instance.attr2('B') }

      it { expect(change2_instance).to be_a(change1_instance.class) }
      it { expect(change2_instance.object_id).not_to eq(change1_instance.object_id) }
      it { expect(change2_instance.attr1).to eq('A') }
      it { expect(change2_instance.attr2).to eq('B') }
      it { expect(change2_instance.attr3).to eq(nil) }
    end

    context 'when attr3 is set' do
      let(:change2_instance) { change1_instance.attr3('C') }

      it { expect(change2_instance).to be_a(change1_instance.class) }
      it { expect(change2_instance.object_id).not_to eq(change1_instance.object_id) }
      it { expect(change2_instance.attr1).to eq('A') }
      it { expect(change2_instance.attr2).to eq(nil) }
      it { expect(change2_instance.attr3).to eq('C') }
    end
  end
end
