# frozen_string_literal: true

require 'eac_ruby_utils/patches/integer/rjust_zero'

RSpec.describe Integer, '#rjust_zero' do
  [
    [0, 1, '0'],
    [9999, 2, '9999'],
    [5, 2, '05'],
    [123, 6, '000123']
  ].each do |sample|
    instance, size, expected_value = sample

    context "when instance is #{instance} and size is #{size}" do
      it do
        expect(instance.rjust_zero(size)).to eq(expected_value)
      end
    end
  end
end
