# frozen_string_literal: true

RSpec.describe EacRubyUtils::ActsAsImmutable::ArrayAccessor do
  let(:stub_class) do
    Class.new do
      include EacRubyUtils::ActsAsImmutable

      immutable_accessor :array_attr, type: :array
    end
  end

  let(:initial_instance) { stub_class.new }

  it do
    expect(initial_instance.array_attrs).to eq([])
  end

  context 'when array_attr pushs for' do
    let(:change1_instance) { initial_instance.array_attr('A') }

    it { expect(change1_instance).to be_a(initial_instance.class) }
    it { expect(change1_instance.object_id).not_to eq(initial_instance.object_id) }
    it { expect(change1_instance.array_attrs).to eq(%w[A]) }

    context 'when array_attrs sets for' do
      let(:change2_instance) { initial_instance.array_attrs(%w[B]) }

      it { expect(change2_instance).to be_a(initial_instance.class) }
      it { expect(change2_instance.object_id).not_to eq(change1_instance.object_id) }
      it { expect(change2_instance.array_attrs).to eq(%w[B]) }
    end

    context 'when array_attrs sets for a non array' do
      let(:change2_instance) { initial_instance.array_attrs('B') }

      it { expect(change2_instance).to be_a(initial_instance.class) }
      it { expect(change2_instance.object_id).not_to eq(change1_instance.object_id) }
      it { expect(change2_instance.array_attrs).to eq(%w[B]) }
    end
  end
end
