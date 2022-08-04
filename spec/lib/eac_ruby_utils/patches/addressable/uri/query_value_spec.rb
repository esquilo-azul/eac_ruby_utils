# frozen_string_literal: true

require 'eac_ruby_utils/patches/addressable/uri/query_value'

RSpec.describe ::Addressable::URI do
  subject(:instance) { described_class.parse('http://example.net') }

  it { expect(instance.query_values).to be_nil }
  it { expect(instance.hash_query_values).to eq({}) }

  it { expect(instance.query_value('param1')).to be_nil }
  it { expect(instance.query_value(:param1)).to be_nil }

  context 'when param is set' do
    let(:set_result) { instance.query_value(:param1, :value1) }

    before { set_result }

    it { expect(set_result).to eq(instance) }
    it { expect(instance.query_values).to eq({ 'param1' => 'value1' }) }
    it { expect(instance.hash_query_values).to eq({ 'param1' => 'value1' }) }
    it { expect(instance.query_value('param1')).to eq('value1') }
    it { expect(instance.query_value(:param1)).to eq('value1') }
  end
end
