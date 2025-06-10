# frozen_string_literal: true

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
