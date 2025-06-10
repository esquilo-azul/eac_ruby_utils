# frozen_string_literal: true

RSpec.describe Module, '#listable' do
  let(:stub_class) do
    Class.new do
      enable_listable
    end
  end

  describe '#enable_listable' do
    it { expect(stub_class.included_modules).to include(EacRubyUtils::Listable) }
  end
end
