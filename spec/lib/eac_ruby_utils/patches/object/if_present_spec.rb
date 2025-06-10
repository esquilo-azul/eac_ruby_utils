# frozen_string_literal: true

RSpec.describe Object, '#if_present' do
  describe '#if_present' do
    it { expect(nil.if_present).to be_nil }
    it { expect(nil.if_present('default')).to eq('default') }
    it { expect(nil.if_present('default') { |_v| 'calculated' }).to eq('default') }
    it { expect('present'.if_present('default')).to eq('present') }
    it { expect('present'.if_present { |v| "#{v}_calculated" }).to eq('present_calculated') }
  end
end
