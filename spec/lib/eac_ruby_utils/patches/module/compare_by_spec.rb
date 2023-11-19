# frozen_string_literal: true

require 'eac_ruby_utils/patches/module/compare_by'

RSpec.describe ::Module, '#compare_by' do
  let(:klass) do
    ::Class.new do
      compare_by :field1, :field2
      attr_reader :field1, :field2

      def initialize(field1, field2)
        @field1 = field1
        @field2 = field2
      end
    end
  end
  let(:o1) { klass.new(1, 2) } # rubocop:disable RSpec/IndexedLet
  let(:o2) { klass.new(2, 1) } # rubocop:disable RSpec/IndexedLet
  let(:o3) { klass.new(1, 1) } # rubocop:disable RSpec/IndexedLet

  describe '#comparable' do
    it { expect(o1).to be < o2 }
    it { expect(o1).to be > o3 }
    it { expect(o2).to be > o3 }
    it { expect([o1, o2, o3].sort).to eq([o3, o1, o2]) }
  end

  describe '#equality' do
    it { expect(o1).not_to eq(o2) }
    it { expect(o1).not_to eq(o3) }
    it { expect(o2).not_to eq(o3) }

    it { expect(o1).to eq(klass.new(1, 2)) }
    it { expect(o2).to eq(klass.new(2, 1)) }
    it { expect(o3).to eq(klass.new(1, 1)) }
  end
end
