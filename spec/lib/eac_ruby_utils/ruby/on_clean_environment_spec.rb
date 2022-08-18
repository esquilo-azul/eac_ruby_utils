# frozen_string_literal: true

require 'eac_ruby_utils/ruby'

RSpec.describe ::EacRubyUtils::Ruby do
  describe '#on_clean_environment' do
    let(:envvar_name) { 'BUNDLE_NOT_EXISTENT_ENV_VAR' }
    let(:envvar_value) { 'any value' }

    before do
      ENV[envvar_name] = envvar_value
    end

    it do # rubocop:disable RSpec/MultipleExpectations
      expect(ENV[envvar_name]).to eq(envvar_value)
      described_class.on_clean_environment do
        expect(ENV[envvar_name]).to eq(nil)
      end
      expect(ENV[envvar_name]).to eq(envvar_value)
    end
  end
end
