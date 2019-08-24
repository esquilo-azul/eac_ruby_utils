# frozen_string_literal: true

require 'eac_ruby_utils/options_consumer'

RSpec.describe ::EacRubyUtils::OptionsConsumer do
  context 'instance created with some data' do
    subject(:instance) { described_class.new(a: 'a_value', b: 'b_value', c: 'c_value') }

    it 'left data should be Hash' do
      expect(instance.left_data).to be_a(::Hash)
    end

    it 'left data should be not empty' do
      expect { instance.validate }.to raise_error(::StandardError)
    end

    it 'parses args' do
      expect(instance.left_data).to eq({ a: 'a_value', b: 'b_value', c: 'c_value' }
          .with_indifferent_access)
      expect(instance.consume(:a)).to eq('a_value')
      expect(instance.left_data).to eq({ b: 'b_value', c: 'c_value' }.with_indifferent_access)
      expect(instance.consume(:c)).to eq('c_value')
      expect(instance.left_data).to eq({ b: 'b_value' }.with_indifferent_access)
      expect(instance.consume(:b)).to eq('b_value')
      expect(instance.left_data).to eq({}.with_indifferent_access)
      instance.validate
    end

    it 'raises if validate has left data' do
      expect(instance.left_data.empty?).to eq(false)
    end
  end

  context '#consume_all' do
    subject(:instance) { described_class.new(a: 'a_value', b: 'b_value', c: 'c_value') }

    it 'return all options in arguments' do
      a, b, d = instance.consume_all(:a, :b, :d)
      expect(a).to eq('a_value')
      expect(b).to eq('b_value')
      expect(d).to eq(nil)
    end
  end
end
