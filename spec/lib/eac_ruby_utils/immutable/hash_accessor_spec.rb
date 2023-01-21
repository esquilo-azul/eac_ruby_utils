# frozen_string_literal: true

require 'eac_ruby_utils/immutable'

::RSpec.describe ::EacRubyUtils::Immutable::HashAccessor do
  let(:stub_class) do
    ::Class.new do
      include ::EacRubyUtils::Immutable

      immutable_accessor :the_hash, type: :hash
    end
  end

  let(:initial_instance) { stub_class.new }

  it { expect(initial_instance.the_hashes).to eq({}) }
  it { expect(initial_instance.the_hash('key_a')).to be_nil }

  context 'when a single value is set' do
    let(:change1_instance) { initial_instance.the_hash('key_a', 'A') }

    before { change1_instance }

    it { expect(initial_instance.the_hashes).to eq({}) }
    it { expect(initial_instance.the_hash('key_a')).to be_nil }
    it { expect(change1_instance.the_hashes).to eq({ 'key_a' => 'A' }) }
    it { expect(change1_instance.the_hash('key_a')).to eq('A') }
  end
end
