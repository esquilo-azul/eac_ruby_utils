# frozen_string_literal: true

require 'active_support/hash_with_indifferent_access'
require 'eac_ruby_utils/yaml'

RSpec.describe ::EacRubyUtils::Yaml do
  let(:unpermitted_class) do
    Class.new do
      def initialize(value)
        @value = value
      end

      def to_s
        @value.to_s
      end
    end
  end

  let(:arrayliable_class) do
    Class.new do
      def initialize(value)
        @value = value
      end

      def to_a
        [@value]
      end
    end
  end

  let(:source) do
    {
      a: 'a', b: :b, c: false, d: true, e: nil,
      f: [
        'f',
        {
          g: 'g',
          h: ::ActiveSupport::HashWithIndifferentAccess.new(
            'i' => ['i', unpermitted_class.new('j')],
            k: arrayliable_class.new('k')
          )
        }
      ]
    }
  end

  let(:target) do
    {
      a: 'a', b: :b, c: false, d: true, e: nil,
      f: ['f', { g: 'g', h: { i: %w[i j], k: ['k'] } }]
    }
  end

  describe '#dump' do
    it { expect(described_class.load(described_class.dump(source))).to eq(target) }
  end

  describe '#sanitize' do
    it { expect(described_class.sanitize(target)).to eq(target) }
  end

  describe '#yaml' do
    {
      ['text'] => false,
      'text' => false,
      "--- Text\n\n" => true,
      "---\n" + ":index: 0\n" + ":codec_name: h264\n" + ":codec_type: video\n" => true,
      '--- - \n bla bla bla' => false,
      "---\n*STRING" => false
    }.each do |source, result|
      it "return #{result} to source \"#{source}\"" do
        expect(described_class.yaml?(source)).to eq(result)
      end
    end
  end
end
