# frozen_string_literal: true

require 'eac_ruby_utils/common_constructor'

RSpec.describe ::EacRubyUtils::CommonConstructor do
  ARG_LIST = %i[a b c d].freeze # rubocop:disable RSpec/LeakyConstantDeclaration

  let(:instance) do
    described_class.new(*ARG_LIST, default: %w[Vcc Vd]) do
      @z = 'Vz'
    end
  end

  let(:a_class) do
    ::Class.new do
      attr_reader :z
    end
  end

  let(:a_class_instance) { a_class.new('Va', 'Vb', 'Vc') }

  before do
    instance.setup_class(a_class)
  end

  it { expect(a_class_instance.z).to eq('Vz') }

  ARG_LIST.each do |attr|
    expected_value = "V#{attr}"
    it "attribute \"#{attr}\" equal to \"#{expected_value}\"" do
      expect(a_class_instance.send(attr)).to eq(expected_value)
    end

    [false, true].each do |include_all|
      it "respond_to?('#{attr}', #{include_all}) == #{include_all}" do
        expect(a_class_instance.respond_to?("#{attr}=", include_all)).to eq(include_all)
      end
    end
  end
end
