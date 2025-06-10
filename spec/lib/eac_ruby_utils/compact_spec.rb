# frozen_string_literal: true

RSpec.describe EacRubyUtils::Compact do
  let(:sub_object) { Struct.new(:c_attr).new('c_value') }
  let(:object) { Struct.new(:a_attr, :b_attr, :sub).new('a_value', 'b_value', sub_object) }
  let(:instance) { described_class.new(object, %w[a_attr b_attr sub.c_attr]) }

  describe '#to_a' do
    it do
      expect(instance.to_a).to eq(%w[a_value b_value c_value])
    end
  end

  describe '#to_h' do
    it do
      expect(instance.to_h).to eq(a_attr: 'a_value', b_attr: 'b_value', 'sub.c_attr': 'c_value')
    end
  end
end
