# frozen_string_literal: true

require 'eac_ruby_utils/compact'

::RSpec.describe ::EacRubyUtils::Compact do
  let(:object) { ::Struct.new(:a_attr, :b_attr).new('a_value', 'b_value') }
  let(:instance) { described_class.new(object, %w[a_attr b_attr]) }

  describe '#to_a' do
    it do
      expect(instance.to_a).to eq(%w[a_value b_value])
    end
  end

  describe '#to_h' do
    it do
      expect(instance.to_h).to eq(a_attr: 'a_value', b_attr: 'b_value')
    end
  end
end
