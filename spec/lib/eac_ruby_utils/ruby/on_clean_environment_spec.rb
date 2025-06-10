# frozen_string_literal: true

RSpec.describe EacRubyUtils::Ruby, '#on_clean_environment' do
  let(:envvar_name) { 'BUNDLE_NOT_EXISTENT_ENV_VAR' }
  let(:envvar_value) { 'any value' }
  let(:noruby_envvar_name) { 'ANY_ENVIRONMENT_VARIABLE' }
  let(:noruby_envvar_value) { 'another any value' }

  before do
    ENV[envvar_name] = envvar_value
    ENV[noruby_envvar_name] = noruby_envvar_value
  end

  it do # rubocop:disable RSpec/MultipleExpectations
    expect(ENV.fetch(envvar_name, nil)).to eq(envvar_value)
    described_class.on_clean_environment do
      expect(ENV.fetch(envvar_name, nil)).to be_nil
    end
    expect(ENV.fetch(envvar_name, nil)).to eq(envvar_value)
  end

  it do # rubocop:disable RSpec/MultipleExpectations
    expect(ENV.fetch(noruby_envvar_name, nil)).to eq(noruby_envvar_value)
    described_class.on_clean_environment do
      expect(ENV.fetch(noruby_envvar_name, nil)).to eq(noruby_envvar_value)
    end
    expect(ENV.fetch(noruby_envvar_name, nil)).to eq(noruby_envvar_value)
  end
end
