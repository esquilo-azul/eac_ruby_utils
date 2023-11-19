# frozen_string_literal: true

require 'eac_ruby_utils/method_class'
require 'eac_ruby_utils/patches/class/static_method_class'

RSpec.describe Class, '#static_method' do
  let(:stub_method_class) do
    described_class.new do
      def self.name
        'StubMethodClass'
      end

      enable_static_method_class
    end
  end

  describe '#enable_static_method_class' do
    it { expect(stub_method_class.included_modules).to include(EacRubyUtils::StaticMethodClass) }
  end
end
