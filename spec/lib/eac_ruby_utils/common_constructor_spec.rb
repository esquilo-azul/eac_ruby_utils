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

  context 'with super class' do
    let(:super_class) do
      ::Class.new do
        attr_reader :super_a, :super_b

        def initialize(a, b) # rubocop:disable Naming/MethodParameterName
          @super_a = a
          @super_b = b
        end
      end
    end

    let(:sub_class) do
      sub_constructor.setup_class(::Class.new(super_class))
    end

    let(:sub_object) { sub_class.new(1, 2, 3, 4) }

    context 'with super_args parameter' do
      let(:sub_constructor) do
        described_class.new(:c, :a, :b, :d, super_args: -> { [c, a] })
      end

      it { expect(sub_object.a).to eq(2) }
      it { expect(sub_object.b).to eq(3) }
      it { expect(sub_object.c).to eq(1) }
      it { expect(sub_object.d).to eq(4) }
      it { expect(sub_object.super_a).to eq(1) }
      it { expect(sub_object.super_b).to eq(2) }
    end

    context 'without super_args parameter' do
      let(:sub_constructor) do
        described_class.new(:c, :a, :b, :d)
      end

      it { expect(sub_object.a).to eq(2) }
      it { expect(sub_object.b).to eq(3) }
      it { expect(sub_object.c).to eq(1) }
      it { expect(sub_object.d).to eq(4) }
      it { expect(sub_object.super_a).to eq(2) }
      it { expect(sub_object.super_b).to eq(3) }
    end

    context 'with undefined super arguments' do
      let(:sub_constructor) do
        described_class.new(:x, :y, :w, :a)
      end

      it do
        expect { sub_object }.to raise_error(::ArgumentError)
      end
    end
  end
end
