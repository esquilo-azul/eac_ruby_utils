# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/listable'

RSpec.describe ::Module do
  let(:stub_class) do
    ::Class.new do
      enable_listable
    end
  end

  describe '#enable_listable' do
    it { expect(stub_class.included_modules).to include(::EacRubyUtils::Listable) }
  end
end
