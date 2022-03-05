# frozen_string_literal: true

require 'eac_ruby_utils/byte'

RSpec.describe ::EacRubyUtils::Byte do
  describe '#[]' do
    let(:instance) { described_class.new(0xDC) }

    [0, 0, 1, 1, 1, 0, 1, 1].each_with_index do |bit_value, bit_index|
      context "when bit index is #{bit_index}" do
        it { expect(instance[bit_index].value).to eq(bit_value) }
      end
    end
  end

  describe '#bit_set' do
    let(:instance) { described_class.new(0b11011100) }

    {
      0 => [0b11011100, 0b11011100, 0b11011000, 0b11010100,
            0b11001100, 0b11011100, 0b10011100, 0b01011100],
      1 => [0b11011101, 0b11011110, 0b11011100, 0b11011100,
            0b11011100, 0b11111100, 0b11011100, 0b11011100]
    }.each do |bit_value, expected_values|
      expected_values.each_with_index do |expected_value, bit_index|
        context "when bit index is #{bit_index} and bit value is #{bit_value}" do
          it do
            expect(instance.bit_set(bit_index, bit_value))
              .to eq(described_class.new(expected_value))
          end
        end
      end
    end
  end

  describe '#from_bit_array' do
    let(:bit_array) { [0, 0, 1, 1, 1, 0, 1, 1] }

    { false => 0b11011100, true => 0b00111011 }.each do |big_endian, expected_integer|
      context "when big-endian is #{big_endian}" do
        let(:expected_value) { described_class.new(expected_integer) }

        it do
          expect(described_class.from_bit_array(bit_array, big_endian)).to eq(expected_value)
        end
      end
    end

    it do
      expect { described_class.from_bit_array([0, 0, 1, 1, 1, 0, 1]) }
        .to raise_error(::ArgumentError)
    end
  end
end
