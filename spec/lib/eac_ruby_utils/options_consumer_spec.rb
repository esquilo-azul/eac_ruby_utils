# frozen_string_literal: true

require 'eac_ruby_utils/options_consumer'

RSpec.describe ::EacRubyUtils::OptionsConsumer do
  context 'with instance created with some data' do
    subject(:instance) { described_class.new(a: 'a_value', b: 'b_value', c: 'c_value') }

    let(:consumed_a) { instance.consume(:a) }
    let(:consumed_b) { instance.consume(:b) }
    let(:consumed_c) { instance.consume(:c) }

    it 'left data should be Hash' do
      expect(instance.left_data).to be_a(::Hash)
    end

    it 'left data should be not empty' do
      expect { instance.validate }.to raise_error(::StandardError)
    end

    context 'when no data is consumed' do
      it do
        expect(instance.left_data).to eq({ a: 'a_value', b: 'b_value', c: 'c_value' }
          .with_indifferent_access)
      end

      it { expect(consumed_a).to eq('a_value') }
    end

    context 'when A value is consumed' do
      before { consumed_a }

      it do
        expect(instance.left_data).to eq({ b: 'b_value', c: 'c_value' }.with_indifferent_access)
      end

      it { expect(instance.consume(:c)).to eq('c_value') }
    end

    context 'when A and C values are consumed' do
      before do
        consumed_a
        consumed_c
      end

      it { expect(instance.left_data).to eq({ b: 'b_value' }.with_indifferent_access) }

      it { expect(consumed_b).to eq('b_value') }
    end

    context 'when all values are consumed' do
      before do
        consumed_a
        consumed_b
        consumed_c
      end

      it { expect(instance.left_data).to eq({}.with_indifferent_access) }

      it do
        expect { instance.validate }.not_to raise_error
      end
    end

    it 'raises if validate has left data' do
      expect(instance.left_data.empty?).to eq(false)
    end
  end

  describe '#consume_all' do
    subject(:instance) { described_class.new(a: 'a_value', b: 'b_value', c: 'c_value') }

    let(:all_consumed) { instance.consume_all(:a, :b, :c, :d) }

    it { expect(all_consumed[0]).to eq('a_value') }
    it { expect(all_consumed[1]).to eq('b_value') }
    it { expect(all_consumed[2]).to eq('c_value') }
    it { expect(all_consumed[3]).to eq(nil) }
  end
end
