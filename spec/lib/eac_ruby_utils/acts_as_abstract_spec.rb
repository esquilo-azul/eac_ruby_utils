# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_abstract'

::RSpec.describe(::EacRubyUtils::ActsAsAbstract) do
  let(:base_class) do
    the_module = described_class
    ::Class.new do
      include the_module

      abstract_methods :method1, :method2

      def method3
        'base result'
      end
    end
  end
  let(:sub_class) do
    ::Class.new(base_class) do
      def method1
        'a result'
      end

      def method4
        'sub result'
      end
    end
  end

  class << self
    def specs_for_target(test_target, instances_hash)
      describe "\##{test_target}" do # rubocop:disable RSpec/EmptyExampleGroup
        specs_for_instances(test_target, instances_hash)
      end
    end

    def specs_for_instances(test_target, instances_hash)
      instances_hash.each do |instance_name, expected_values|
        context "when instance is \"#{instance_name}\"" do # rubocop:disable RSpec/EmptyExampleGroup
          let(:instance) { send("#{instance_name}_class").new }

          specs_for_methods_values(test_target, expected_values)
        end
      end
    end

    def specs_for_methods_values(test_target, expected_values)
      expected_values.each_with_index do |expected_value, method_index|
        method_name = "method#{method_index + 1}"
        context "when method is \"#{method_name}\"" do # rubocop:disable RSpec/EmptyExampleGroup
          send("specs_for_#{test_target}", method_name, expected_value)
        end
      end
    end

    def specs_for_method_missing(method_name, expected_value)
      if expected_value.is_a?(::Class) && expected_value < ::Exception
        it do
          expect { instance.send(method_name) }.to raise_error(expected_value)
        end
      else
        it do
          expect(instance.send(method_name)).to eq(expected_value)
        end
      end
    end

    def specs_for_respond_to_missing(method_name, expected_value)
      it { expect(instance.respond_to?(method_name)).to eq(expected_value) }
    end
  end

  {
    method_missing: {
      base: [::NoMethodError, ::NoMethodError, 'base result', ::NoMethodError],
      sub: ['a result', ::NoMethodError, 'base result', 'sub result']
    },
    respond_to_missing: {
      base: [true, true, true, false],
      sub: [true, true, true, true]
    }
  }.each do |test_target, instances_hash|
    specs_for_target(test_target, instances_hash)
  end
end
