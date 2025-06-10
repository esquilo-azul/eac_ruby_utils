# frozen_string_literal: true

RSpec.describe Object, '#call_if_proc' do
  describe '#call_if_proc' do
    it { expect(nil.call_if_proc).to be_nil }
    it { expect('a string'.call_if_proc).to eq('a string') }
    it { expect(-> { 'a returned value' }.call_if_proc).to eq('a returned value') }
  end
end
