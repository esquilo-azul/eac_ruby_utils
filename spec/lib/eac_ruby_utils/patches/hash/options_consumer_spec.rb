# frozen_string_literal: true

require 'eac_ruby_utils/patches/hash/options_consumer'

RSpec.describe ::Hash, '#options_consumer' do
  let(:a_hash) { { a: 'a_value', b: 'b_value', c: 'c_value' } }
  let(:instance) { a_hash.to_options_consumer }

  it 'returns a OptionsConsumer' do
    expect(instance).to be_a(::EacRubyUtils::OptionsConsumer)
  end

  it do
    expect(instance.left_data).to eq({ a: 'a_value', b: 'b_value', c: 'c_value' }
      .with_indifferent_access)
  end
end
