# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'

RSpec.describe ::EacRubyUtils::CommonConstructor do
  ARG_LIST = %i[a b c d].freeze
  let(:instance) { described_class.new(*ARG_LIST, default: %w[Vcc Vd]) }

  class MyClass
  end

  let(:subject) { MyClass.new('Va', 'Vb', 'Vc') }

  before do
    instance.setup_class(::MyClass)
  end

  ARG_LIST.each do |attr|
    expected_value = "V#{attr}"
    it "attribute \"#{attr}\" equal to \"#{expected_value}\"" do
      expect(subject.send(attr)).to eq(expected_value)
    end
    [false, true].each do |include_all|
      it "respond_to?('#{attr}', #{include_all}) == #{include_all}" do
        expect(subject.respond_to?("#{attr}=", include_all)).to eq(include_all)
      end
    end
  end
end
