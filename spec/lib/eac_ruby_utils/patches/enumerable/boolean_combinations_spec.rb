# frozen_string_literal: true

require 'eac_ruby_utils/patches/enumerable/boolean_combinations'

RSpec.describe Enumerable, '#boolean_combinations' do
  let(:empty_instance) { [].to_enum }
  let(:a_instance) { [:a].to_enum }
  let(:ab_instance) { %i[a b].to_enum }

  describe '#bool_hash_combs' do
    it do
      expect(empty_instance.bool_hash_combs).to eq([])
    end

    it do
      expect(a_instance.bool_hash_combs).to eq([{ a: false }, { a: true }])
    end

    it do
      expect(ab_instance.bool_hash_combs)
        .to eq([{ a: false, b: false }, { a: false, b: true }, { a: true, b: false },
                { a: true, b: true }])
    end
  end

  describe '#bool_array_combs' do
    it do
      expect(empty_instance.bool_array_combs).to eq([])
    end

    it do
      expect(a_instance.bool_array_combs).to eq([[], [:a]])
    end

    it do
      expect(ab_instance.bool_array_combs).to eq([[], [:a], [:b], %i[a b]])
    end
  end
end
