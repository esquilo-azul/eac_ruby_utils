# frozen_string_literal: true

require 'eac_ruby_utils/patches/object/recursive_build'

RSpec.describe Object, '#recursive_build' do
  let(:item_class) do
    Class.new do
      class << self
        def create(label, dependencies_keys)
          item = new(label, dependencies_keys)
          registry[item.label] = item
          item
        end

        def registry
          @registry ||= {}
        end
      end

      attr_reader :label, :dependencies_keys

      def initialize(label, dependencies_keys)
        @label = label
        @dependencies_keys = dependencies_keys.freeze
      end

      def dependencies
        dependencies_keys.map { |key| self.class.registry.fetch(key) }
      end

      def to_s
        label
      end
    end
  end

  items = [
    [:a, %w[c], %w[a c]],
    [:b, %w[a], %w[b a c]],
    [:c, [], %w[c]],
    [:d, %w[a b c e], %w[d a b c e]],
    [:e, %w[c b], %w[e c b a]]
  ]

  items.each do |item|
    let(item[0]) { item_class.create(item[0].to_s, item[1]) }
    before { send(item[0]) }
  end

  describe '#result' do
    items.each do |item|
      context "when root is \"#{item[0]}\"" do
        let(:root) { send(item[0]) }
        let(:dependencies) { item[2].map { |d| send(d) } }

        it "is #{item[2]}" do
          expect(root.recursive_build(&:dependencies)).to eq(dependencies)
        end
      end
    end
  end
end
