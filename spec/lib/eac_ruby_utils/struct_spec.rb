# frozen_string_literal: true

require 'eac_ruby_utils/struct'

RSpec.describe ::EacRubyUtils::Struct do
  let(:instance) { described_class.new('a' => 1, b: '') }
  let(:other) { described_class.new('a' => 'm1', c: 'm2') }

  describe '#[]' do
    it { expect(instance[:a]).to eq(1) }
    it { expect(instance['a']).to eq(1) }
    it { expect(instance[:a?]).to eq(true) }
    it { expect(instance['a?']).to eq(true) }
    it { expect(instance[:b]).to eq('') }
    it { expect(instance['b']).to eq('') }
    it { expect(instance[:b?]).to eq(false) }
    it { expect(instance['b?']).to eq(false) }
    it { expect(instance[:c]).to eq(nil) }
    it { expect(instance['c']).to eq(nil) }
    it { expect(instance[:c?]).to eq(false) }
    it { expect(instance['c?']).to eq(false) }
  end

  describe '#fetch' do
    it { expect(instance.fetch(:a)).to eq(1) }
    it { expect(instance.fetch('a')).to eq(1) }
    it { expect(instance.fetch(:a?)).to eq(true) }
    it { expect(instance.fetch('a?')).to eq(true) }
    it { expect(instance.fetch(:b)).to eq('') }
    it { expect(instance.fetch('b')).to eq('') }
    it { expect(instance.fetch(:b?)).to eq(false) }
    it { expect(instance.fetch('b?')).to eq(false) }
    it { expect { instance.fetch(:c) }.to raise_error(::KeyError) }
    it { expect { instance.fetch('c') }.to raise_error(::KeyError) }
    it { expect { instance.fetch(:c?) }.to raise_error(::KeyError) }
    it { expect { instance.fetch('c?') }.to raise_error(::KeyError) }
  end

  describe '#merge' do
    let(:merged) { instance.merge(other) }

    it { expect(merged.to_h).to eq(a: 'm1', b: '', c: 'm2') }
  end

  describe '#property_method' do
    it { expect(instance.a).to eq(1) }
    it { expect(instance.a?).to eq(true) }
    it { expect(instance.b).to eq('') }
    it { expect(instance.b?).to eq(false) }
    it { expect { instance.c }.to raise_error(::NoMethodError) }
    it { expect { instance.c? }.to raise_error(::NoMethodError) }
  end

  describe '#to_h' do
    it { expect(instance.to_h).to eq(a: 1, b: '') }
  end
end
