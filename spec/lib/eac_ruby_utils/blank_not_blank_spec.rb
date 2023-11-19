# frozen_string_literal: true

require 'eac_ruby_utils/blank_not_blank'

RSpec.describe EacRubyUtils::BlankNotBlank do
  let(:instance) { described_class.instance }

  it do
    expect { described_class.new }.to raise_error(NoMethodError)
  end

  it { expect(instance).to be_present }
  it { expect(instance).not_to be_blank }
  it { expect(instance).to be_truthy }
  it { expect(instance).to eq('') }
end
