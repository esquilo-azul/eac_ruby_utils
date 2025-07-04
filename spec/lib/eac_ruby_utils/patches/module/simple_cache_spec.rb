# frozen_string_literal: true

RSpec.describe Module, '#simple_cache' do
  let(:stub_class) do
    Class.new do
      enable_simple_cache
    end
  end

  describe '#enable_simple_cache' do
    it { expect(stub_class.included_modules).to include(EacRubyUtils::SimpleCache) }
  end
end
