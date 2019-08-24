# frozen_string_literal: true

require 'eac_ruby_utils/console/speaker'

RSpec.describe ::EacRubyUtils::Console::Speaker do
  let(:instance) do
    r = ::Object.new
    r.extend(described_class)
    r
  end

  context '#request_input' do
    it 'recover value from hash list' do
      allow(instance).to receive(:request_string).and_return('opt1')
      list = { opt1: 'value1', opt2: 'value2' }
      expect(instance.request_input('Question', list: list)).to eq('value1')
    end

    it 'recover value from array list' do
      allow(instance).to receive(:request_string).and_return('OPT1')
      list = %w[opt1 opt2]
      expect(instance.request_input('Question', list: list)).to eq('opt1')
    end
  end
end
