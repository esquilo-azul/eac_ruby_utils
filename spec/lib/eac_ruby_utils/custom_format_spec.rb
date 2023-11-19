# frozen_string_literal: true

require 'eac_ruby_utils/custom_format'

class StubObjectData
  def x_value
    'X1'
  end

  def y_value
    'Y1'
  end
end

RSpec.describe EacRubyUtils::CustomFormat do
  let(:instance) { described_class.new(x: :x_value, y: :y_value, z: :unexistent) }
  let(:ok_format) { instance.format('|%%|%y|%x|%y|') }
  let(:ok_string_expected) { '|%|Y1|X1|Y1|' }
  let(:fail_format) { instance.format('|%z|') }

  it do
    expect(ok_format.sequences).to include(:x, :y)
  end

  it do
    expect(fail_format.sequences).to include(:z)
  end

  context 'when object source is a hash' do
    let(:object_source) { { x_value: 'X1', y_value: 'Y1' } }

    context 'when hash has all keys' do
      it do
        expect(ok_format.with(object_source)).to eq(ok_string_expected)
      end
    end

    context 'when hash has not all keys' do
      it do
        expect(fail_format.with(object_source)).to eq('||')
      end
    end
  end

  context 'when object source is not a hash' do
    let(:object_source) { StubObjectData.new }

    context 'when object has all methods' do
      it do
        expect(ok_format.with(object_source)).to eq(ok_string_expected)
      end
    end

    context 'when object has not all methods' do
      it do
        expect { fail_format.with(object_source) }.to raise_error(ArgumentError)
      end
    end
  end
end
