# frozen_string_literal: true

require 'eac_ruby_utils/patches/enumerator/current'

RSpec.describe ::Enumerator, '#current' do
  let(:list) { %w[a b] }
  let(:instance) { list.each }

  it { expect(instance).to be_a(described_class) }
  it { expect(instance.current).to eq('a') }

  context 'with first next' do
    before { instance.next }

    it { expect(instance.current).to eq('b') }
  end

  context 'with last next' do
    before do
      instance.next
      instance.next
    end

    it { expect(instance.current).to be_nil }
  end
end
