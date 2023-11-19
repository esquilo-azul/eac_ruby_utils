# frozen_string_literal: true

require 'eac_ruby_utils/patches/enumerator/stopped'

RSpec.describe Enumerator, '#stopped' do
  let(:list) { %w[a b] }
  let(:instance) { list.each }

  it { expect(instance).to be_a(described_class) }
  it { expect(instance.peek).to eq('a') }
  it { expect(instance).to be_ongoing }
  it { expect(instance).not_to be_stopped }

  context 'with first next' do
    before { instance.next }

    it { expect(instance.peek).to eq('b') }
    it { expect(instance).to be_ongoing }
    it { expect(instance).not_to be_stopped }
  end

  context 'with last next' do
    before do
      instance.next
      instance.next
    end

    it { expect { instance.peek }.to raise_error(StopIteration) }
    it { expect(instance).not_to be_ongoing }
    it { expect(instance).to be_stopped }
  end
end
