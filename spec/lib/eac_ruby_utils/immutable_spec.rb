# frozen_string_literal: true

::RSpec.describe ::EacRubyUtils::Immutable do
  let(:stub_class) do
    the_described_class = described_class
    ::Class.new do
      include the_described_class

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
  end
end
