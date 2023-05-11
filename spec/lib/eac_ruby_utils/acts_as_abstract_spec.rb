# frozen_string_literal: true

require 'eac_ruby_utils/acts_as_abstract'

RSpec.describe(::EacRubyUtils::ActsAsAbstract) do
  let(:base_class) do
    the_module = described_class
    ::Class.new do
      include the_module

      abstract_methods :method1, :method2
    end
  end
  let(:base_instance) { base_class.new }
  let(:sub_class) do
    ::Class.new(base_class) do
      def method1
        'a result'
      end
    end
  end
  let(:sub_instance) { sub_class.new }

  it { expect { base_instance.method1 }.to raise_error(::NoMethodError) }
  it { expect { base_instance.method2 }.to raise_error(::NoMethodError) }
  it { expect(sub_instance.method1).to eq('a result') }
  it { expect { sub_instance.method2 }.to raise_error(::NoMethodError) }
end
