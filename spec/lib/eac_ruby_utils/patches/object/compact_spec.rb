# frozen_string_literal: true

RSpec.describe Object, '#compact' do
  let(:instance) { Struct.new(:a_attr, :b_attr).new('a_value', 'b_value') }
  let(:attributes) { %w[a_attr b_attr] }

  describe '#compact' do
    it do
      expect(instance.compact_to_a(*attributes)).to eq(%w[a_value b_value])
    end
  end

  describe '#to_h' do
    it do
      expect(instance.compact_to_h(*attributes)).to eq(a_attr: 'a_value', b_attr: 'b_value')
    end
  end
end
