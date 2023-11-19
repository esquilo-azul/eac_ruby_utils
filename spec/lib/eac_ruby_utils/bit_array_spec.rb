# frozen_string_literal: true

require 'eac_ruby_utils/bit_array'

RSpec.describe EacRubyUtils::BitArray do
  describe '#to_byte_array' do
    let(:instance) { described_class.new([0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1]) }

    {
      false => [0xF0, 0xDC],
      true => [0x0F, 0x3B]
    }.each do |big_endian, expected_bytes|
      context "when big-endian is #{big_endian}" do
        let(:expected_value) { EacRubyUtils::ByteArray.new(expected_bytes) }

        it do
          expect(instance.to_byte_array(big_endian)).to eq(expected_value)
        end
      end
    end
  end
end
