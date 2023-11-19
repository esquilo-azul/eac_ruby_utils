# frozen_string_literal: true

require 'eac_ruby_utils/method_class'
require 'eac_ruby_utils/patches/class/method_class'

RSpec.describe Class, '#method_class' do
  let(:stub_method_class) do
    described_class.new do
      def self.name
        'StubMethodClass'
      end

      enable_method_class
    end
  end

  describe '#enable_simple_cache' do
    it { expect(stub_method_class.included_modules).to include(EacRubyUtils::MethodClass) }
  end
end
