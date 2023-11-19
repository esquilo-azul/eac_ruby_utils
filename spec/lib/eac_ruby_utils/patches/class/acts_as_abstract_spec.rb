# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_abstract'
require 'eac_ruby_utils/patches/module/acts_as_abstract'

::RSpec.describe ::Class, '#acts_as_abstract' do
  let(:stub_class) do
    described_class.new { acts_as_abstract }
  end

  describe '#acts_as_abstract' do
    it { expect(stub_class.included_modules).to include(::EacRubyUtils::ActsAsAbstract) }
  end
end
