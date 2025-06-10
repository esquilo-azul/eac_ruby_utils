# frozen_string_literal: true

RSpec.describe Class, '#acts_as_abstract' do
  let(:stub_class) do
    described_class.new { acts_as_abstract }
  end

  describe '#acts_as_abstract' do
    it { expect(stub_class.included_modules).to include(EacRubyUtils::ActsAsAbstract) }
  end
end
