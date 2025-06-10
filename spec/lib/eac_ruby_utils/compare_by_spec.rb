# frozen_string_literal: true

RSpec.describe EacRubyUtils::CompareBy do
  let(:instance) { described_class.new(%i[field1 field2]) }
  let(:klass) do
    Class.new do
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

  before { instance.apply(klass) }

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
