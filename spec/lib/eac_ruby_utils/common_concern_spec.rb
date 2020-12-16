# frozen_string_literal: true

require 'eac_ruby_utils/common_concern'

RSpec.describe ::EacRubyUtils::CommonConcern do
  let(:instance) do
    described_class.new do
      self.valor = 'changed'
    end
  end

  let(:stub_module) do
    ::Module.new do
      module ClassMethods # rubocop:disable RSpec/LeakyConstantDeclaration
        def my_class_method
          'class'
        end
      end

      module InstanceMethods # rubocop:disable RSpec/LeakyConstantDeclaration
        def my_instance_method
          'instance'
        end
      end
    end
  end

  let(:stub_class) do
    ::Class.new do
      class << self
        attr_accessor :valor
      end
    end
  end

  let(:stub_class_instance) { stub_class.new }

  before do
    instance.setup(stub_module)
    stub_class.include stub_module
  end

  it { expect(stub_class_instance.my_instance_method).to eq('instance') }
  it { expect(stub_class_instance.class.my_class_method).to eq('class') }
  it { expect(stub_class_instance.class.valor).to eq('changed') }
end
