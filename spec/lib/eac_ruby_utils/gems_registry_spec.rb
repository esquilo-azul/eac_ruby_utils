# frozen_string_literal: true

RSpec.describe EacRubyUtils::GemsRegistry do
  let(:instance) { described_class.new('Byte') }

  it do
    expect(instance.registered.map(&:registered_module)).to include(EacRubyUtils::Byte)
  end

  it do
    expect(instance.registered.find { |e| e.gemspec.name == 'eac_ruby_utils' }.path_to_require)
      .to eq('eac_ruby_utils/byte')
  end
end
