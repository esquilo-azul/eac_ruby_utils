# frozen_string_literal: true

require 'eac_ruby_utils/enum'

RSpec.describe EacRubyUtils::Enum do
  let(:klass) do
    Class.new(described_class) do
      attr_reader :color

      def initialize(key, color = :none)
        super(key)
        @color = color
      end

      enum :horse
      enum :pig, [:pink]
      enum(:dog, :white)
      enum(:cat) { :black }
    end
  end

  it { expect(klass.horse).to be_a(klass) }
  it { expect(klass.pig).to be_a(klass) }
  it { expect(klass.dog).to be_a(klass) }
  it { expect(klass.cat).to be_a(klass) }

  it { expect(klass.horse.color).to eq(:none) }
  it { expect(klass.pig.color).to eq(:pink) }
  it { expect(klass.dog.color).to eq(:white) }
  it { expect(klass.cat.color).to eq(:black) }

  it { expect(klass.const_get(:HORSE)).to eq(klass.horse) }
  it { expect(klass.const_get(:PIG)).to eq(klass.pig) }
  it { expect(klass.const_get(:DOG)).to eq(klass.dog) }
  it { expect(klass.const_get(:CAT)).to eq(klass.cat) }

  it { expect(klass.values).to eq([klass.horse, klass::PIG, klass.dog, klass::CAT]) }

  describe '#enum' do
    it do
      expect { klass.enum(:PiG) }.to raise_error(ArgumentError)
    end
  end
end
