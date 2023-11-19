# frozen_string_literal: true

require 'eac_ruby_utils/arguments_consumer'

RSpec.describe ::EacRubyUtils::ArgumentsConsumer do
  let(:instance) { described_class.new(%i[a b c d], d: 'd_value') }
  let(:args) { ['a_value', 'b_value', e: 'e_value'] }
  let(:result) { instance.parse(args) }

  it { expect(result).to be_a(::Hash) }
  it { expect(result.count).to eq(5) }
  it { expect(result.fetch(:a)).to eq('a_value') }
  it { expect(result.fetch(:b)).to eq('b_value') }
  it { expect(result.fetch(:c)).to be_nil }
  it { expect(result.fetch(:d)).to eq('d_value') }
  it { expect(result.fetch(:e)).to eq('e_value') }
end
