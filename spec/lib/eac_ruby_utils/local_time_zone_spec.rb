# frozen_string_literal: true

RSpec.describe(EacRubyUtils::LocalTimeZone) do
  describe '#auto' do
    context 'when TZ environment variable is set' do
      let(:expected_time_zone) { 'America/Sao_Paulo' }

      before do
        ENV['TZ'] = expected_time_zone
      end

      it { expect(described_class.auto).to eq(expected_time_zone) }
    end
  end
end
