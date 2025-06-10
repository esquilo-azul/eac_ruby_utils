# frozen_string_literal: true

RSpec.describe Hash, '#if_key' do
  subject(:instance) { { a: 'a_value' } }

  it do
    expect(instance.if_key(:a)).to eq('a_value')
  end

  it do
    expect(instance.if_key(:a) { |v| "_#{v}_" }).to eq('_a_value_')
  end

  it do
    expect(instance.if_key(:b)).to be_nil
  end

  it do
    expect(instance.if_key(:b, 'default_value')).to eq('default_value')
  end
end
